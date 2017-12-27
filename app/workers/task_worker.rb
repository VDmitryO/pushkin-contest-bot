class TaskWorker
  include Sidekiq::Worker

  def perform(params)
    task = Task.new(params)
    task.save
    # Do something
  end
end
