class PhotoRecognitionJob < ActiveJob::Base
  queue_as :pack

  def perform(problem_id)
    problem = Problem.find(problem_id)

    photo = File.new("photo.png","r+")
    photo.syswrite(problem.picture.read)
    photo.close
    result = `python RF_script.py ./photo.png`

    if result[0] == "1"
      self.set(tag: "54f6bbf5695a390e79110000")
    elsif result[0] == "2"
      self.set(tag: "54f6b970695a390e79090000")
    elsif result[0] == "3"
      self.set(tag: "54f6b97a695a390e790b0000")
    elsif result[0] == "4"
      self.set(tag: "54f6bbec695a390e790f0000")
    elsif result[0] == "5"
      self.set(tag: "54f6bbe3695a390e790d0000")
    end

    # distribution
    DistributeProblemJob.perform_later(problem.id.to_s)
    # schedule a job to close itself at deadline
    CloseProblemJob.set(wait: self.duration.minutes).perform_later(problem.id.to_s)
  end
end
