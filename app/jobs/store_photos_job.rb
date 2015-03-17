class StorePhotosJob < ActiveJob::Base
  queue_as :pack

  def perform(problem_id)
    subject = "problem #{problem_id}"
    problem = Problem.find(problem_id)

    if problem.tag.name == "包"
      filename = "photos/bag/#{problem.id}.png"
    elsif problem.tag.name == "帽子"
      filename = "photos/hat/#{problem.id}.png"
    elsif problem.tag.name == "衬衣"
      filename = "photos/shirt/#{problem.id}.png"
    elsif problem.tag.name == "鞋子"
      filename = "photos/shoes/#{problem.id}.png"
    elsif problem.tag.name == "裤子"
      filename = "photos/trousers/#{problem.id}.png"
    end

    photo = File.new(filename, "w+")
    photo.syswrite(problem.picture.read)
    photo.close
  end
end
