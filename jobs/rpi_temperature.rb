require 'net/ssh'
require 'json'
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '20s', :first_in => 0 do |job|
  targets = JSON.parse(ENV['SERVERS'])
  targets.each do |server|
    Net::SSH.start(server['ip'], server['user_id'], :password => server['password']) do |ssh|
      value = ssh.exec!('cat /sys/class/thermal/thermal_zone*/temp').gsub("\n","").to_i/1000
      send_event("#{server['name']}_temp", { value: value })
      puts "#{server['name']}_temp", { value: value }
    end
  end
end