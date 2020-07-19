class Enqueuer
  attr_accessor :queue

  def initialize
    queue = []
  end
  
  def enqueue(objects: [], actions: {}, default_interval: '20s')
    jobs = objects.map do |object|
      interval = object.interval || default_interval
      job = SshJob.new(object, actions)
      SCHEDULER.every interval, job
    end
    queue = queue + jobs
  end
end