class ResultVotingJob < ActiveJob::Base
  queue_as :ibc

  def perform(problem_id)
    problem = Problem.find(problem_id)

    # 初始化results，只取最早回答的amount个solutions
    results = problem.solutions.where(status: :solved).asc(:updated_at).take(problem.amount)
    
    # 检索所有分词出现的频率
    segments = Hash.new()
    results.each { |solution|
      solution.result.each_char { |word|
        if segments.include?(word)
          segments[word] = segments[word] + 1
        else
          segments[word] = 1
        end
      }
    }

    # 去掉出现频率低（不过半数）的分词
    segments.delete_if { |key, value| value < results.size/2 + 1 }

    # 统计各个solution的result包含高频分词的数量
    figure = Hash.new()
    problem_result = results.first
    results.each { |solution|
      figure[solution.result] = 0
      segments.each_key { |word|
        if solution.result.include?(word)
          figure[solution.result] = figure[solution.result] + 1
        end
      }
      if figure[solution.result] > figure[problem_result.result]
        problem_result = solution
      end
    }
    problem.result = problem_result.result
    problem.save!

    # 向Seeker推送结果
    user_id = problem.creator.id.to_s
    title = "您的问题有新的答案："
    content = problem.result
    uri = problem.to_uri
    PushNotificationJob.perform_later(title, content, uri, user_id)
  end
end
