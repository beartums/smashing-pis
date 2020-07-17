require 'net/ssh'

SCHEDULER.every '60s', :first_in => 0 do
  targets = JSON.parse(ENV['SERVERS'])
  server = targets.find {|s| s["name"] == "GrifGateway"}
  res = []
  Net::SSH.start(server["ip"], server['user_id'], :password => server['password']) do |ssh|

    res << {
        label: 'sabnzbd',
        value: ssh.exec!('docker exec sabnzbd curl -s icanhazip.com').gsub("\n","")
      }

    res << {
        label: 'transmission',
        value: ssh.exec!('docker exec transmission curl -s icanhazip.com').gsub("\n","")
      }
  end
    
  send_event('external_ips', { items: res })
end