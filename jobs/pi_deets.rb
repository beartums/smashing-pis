require 'net/ssh'
require 'json'
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '20s', :first_in => 0 do |job|
  Constants::SERVERS.each do |server|
    Net::SSH.start(server['ip'], server['user_id'], :password => server['password']) do |ssh|
      temp = temperature(ssh)
      pct_active = cpu_activity(ssh)
      
      send_event("#{server['name']}_cpu", { value: pct_active })
      send_event("#{server['name']}_temp", { value: temp })
    end
  end
end

def temperature(ssh)
  ssh.exec!('cat /sys/class/thermal/thermal_zone*/temp').gsub("\n","").to_i/1000
end

def cpu_activity(ssh)
  pct_idle = ssh.exec!("mpstat -P ALL| awk '{ if ($2==\"all\" || $3==\"all\") {print $NF}}'").to_f
  begin
    (100 - pct_idle).round(0)
  rescue JSON::ParserError, NoMethodError
    "N/A"
  end
end
