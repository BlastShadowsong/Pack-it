class PhotoRecognitionJob < ActiveJob::Base
  queue_as :pack

  def perform(problem_id)
    problem = Problem.find(problem_id)

    photo = File.new("photo.png","r+")
    photo.syswrite(problem.picture.read)
    photo.close
    result = exec("python RF_script.py ./photo.png")

    if result == 1
      problem.set(tag: "54f6bbf5695a390e79110000")
    elsif result == 2
      problem.set(tag: "54f6b970695a390e79090000")
    elsif result == 3
      problem.set(tag: "54f6b97a695a390e790b0000")
    elsif result == 4
      problem.set(tag: "54f6bbec695a390e790f0000")
    elsif result == 5
      problem.set(tag: "54f6bbe3695a390e790d0000")
    end

  end
end
