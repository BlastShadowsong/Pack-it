class PhotoRecognitionJob < ActiveJob::Base
  queue_as :pack

  def perform(problem_id)
    problem = Problem.find(problem_id)

    photo = File.new("photo.png","r+")
    photo.syswrite(problem.picture.read)
    photo.close
    result = exec("python RF_script.py ./photo.png")

  end
end
