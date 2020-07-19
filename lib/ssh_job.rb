require 'net/ssh'

class SshJob
  attr_accessor :target, :actions

  def initialize(target:, actions: {})
    target = target
    actions = actions
  end

  def call
    begin
      results = []
      Net::SSH.start(target['ip'], target['user_id'], :password => target['password']) do |ssh|
        results = actions.map do |action|
          ssh.exec!(action.remote_action)
        end
      end
      send_event("#{target['name']}_temp", temp.merge(moreinfo: target["ip"]))
      send_event("#{target['name']}_cpu", activity.merge(moreinfo: target["ip"]))
    rescue
      send_event("#{target['name']}_temp", { moreinfo: target["ip"], status: 'offline' })
      send_event("#{target['name']}_cpu", { moreinfo: target["ip"], status: 'offline' })
    end
  end
end