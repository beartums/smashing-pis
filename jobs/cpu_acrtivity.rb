require 'net/ssh'
require 'json'
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '20s', :first_in => 0 do |job|
  targets = JSON.parse(ENV['SERVERS'])
  targets.each do |server|
    Net::SSH.start(server['ip'], server['user_id'], :password => server['password']) do |ssh|
      response = ssh.exec!('mpstat -P ALL -o JSON')
      begin
        values = JSON.parse(response)
        pct_idle = values["sysstat"]['hosts'][0]['statistics'][0]['cpu-load'][0]['idle']
        pct_active = 100 - values[0]["idle"]
        send_event("#{server['name']}_cpu", { value: pct_active })
      rescue JSON::ParserError, NoMethodError
        pct_active = "N/A"
      ensure
        send_event("#{server['name']}_cpu", { value: pct_active })
      end
    end
  end
end

=begin
Sample data
 "Linux 5.4.20-rockchip64 (GrifRock1) \t06/26/2020 \t_aarch64_\t(4 CPU)\n\n07:56:21 AM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle\n07:56:21 AM  all    0.49    0.00    0.23    0.02    0.00    0.01    0.00    0.00    0.00   99.25\n07:56:21 AM    0    0.46    0.00    0.24    0.01    0.00    0.04    0.00 
0.00    0.00   99.24\n07:56:21 AM    1    0.50    0.00    0.24    0.02    0.00    0.00    0.00    0.00    0.00   99.24\n07:56:21 AM    2    0.50    0.00    0.21    0.03  
0.00    0.00    0.00    0.00    0.00   99.25\n07:56:21 AM    3    0.49    0.00    0.23    0.01    0.00    0.00    0.00    0.00    0.00   99.26\n"
=end