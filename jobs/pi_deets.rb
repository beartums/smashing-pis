require 'net/ssh'
require 'json'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '30s', :first_in => 0 do |job|
  pi_action = RemoteActions::PiTemp.new
  cpu_action = RemoteActions::PiCpuActivity.new

  Constants::SERVERS.each do |server|
    results = []
    temp = nil
    activity = nil
    begin
      ssh = Net::SSH.start(server['ip'], server['user_id'], :password => server['password']) 
    rescue StandardError => e
      pi_action.send(server, 'OL', e.message, status: 'offline')
      cpu_action.send(server,'OL', e.message, status: 'offline')
    else
      pi_action.call(server, ssh)
      cpu_action.call(server, ssh)
    end
  end
end

def pi_temperature(ssh)
  { value: ssh.exec!(Constants::RPI_TEMP_MILLICELSIUS_COMMAND).to_f.round(0)/1000 }
end

def pi_cpu_activity(ssh)
  result = {}
  ssh.exec! Constants::RPI_IDLE_CPU_PERCENT_COMMAND do |ch, stream, data|
    if stream == :stderr
      result = { 
        value: '???',
        error: data
      } 
    else
      result = { value: (100 - data.to_f).round(0) }
    end
  end
  result
end
