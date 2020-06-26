require 'net/ssh'

SCHEDULER.every '60s' do
  targets = JSON.parse(ENV['SERVERS'])
  Net::SSH.start('192.168.0.24', 'pi', :password => ENV['password']) do |ssh|
    server = targets.find_by("name" => "GrifGateway")
    res = [
      {
        label: 'sabnzbd',
        value: ssh.exec!('docker exec sabnzbd curl -s icanhazip.com').gsub("\n","")
      },
      {
        label: 'transmission',
        value: ssh.exec!('docker exec transmission curl -s icanhazip.com').gsub("\n","")
      }
    ]
  end
    
  send_event('external_ips', { items: res })
  puts(res )
end