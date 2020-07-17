require 'net/ssh'
require 'json'

MPSTAT_CPU_IDLE = "mpstat -u 1 1| awk '{ if ($2==\"all\" || $3==\"all\") {print $NF}}'"
TOP_CPU_IDLE = "top -n 1 | grep %Cpu\(s\) | awk '{print $8}'"
IOSTAT_CPU_IDLE = "iostat -c 1 2 | sed -n 8p | awk '{ print $6}'"

START_SAR = "sudo sar -o -u 20  >/dev/null 2>&1 &"
SAR_CPU_STATS_60S = "sar -f -u -s $(date --date=\"@$(($(date +%s)-60))\" +%H:%M:%S) -e $(date +%H:%M:%S)"
SAR_CPU_STATS_OBJ_FORMAT = " | sed -r -n '/(%|Average)/p' | sed -r ' s/\s{2,}/,/g'"
SAR_CPU_STATS_CPU_IDLE = "sar -f -u -s $(date --date=\"@$(($(date +%s)-60))\" +%H:%M:%S) -e $(date +%H:%M:%S) | grep Average | awk '{ print $8 }'"

SYS_TEMP_MILLICELSIUS = 'cat /sys/class/thermal/thermal_zone*/temp'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '30s', :first_in => 0 do |job|
  Constants::SERVERS.each do |server|
    temp = nil
    activity = nil
    begin
      Net::SSH.start(server['ip'], server['user_id'], :password => server['password']) do |ssh|
        temp = pi_temperature(ssh)
        activity = pi_cpu_activity(ssh)    
      end
      send_event("#{server['name']}_temp", temp.merge(moreinfo: server["ip"]))
      send_event("#{server['name']}_cpu", activity.merge(moreinfo: server["ip"]))
    rescue
      send_event("#{server['name']}_temp", { moreinfo: server["ip"], status: 'offline' })
      send_event("#{server['name']}_cpu", { moreinfo: server["ip"], status: 'offline' })
    end
  end
end

def pi_temperature(ssh)
  { value: ssh.exec!(SYS_TEMP_MILLICELSIUS).to_i/1000 }
end

def pi_cpu_activity(ssh)
  result = {}
  ssh.exec! SAR_CPU_STATS_CPU_IDLE do |ch, stream, data|
    if stream == :stderr
      result = { error: data, value: "N/A" }
    else
      result = { value: (100 - data.to_f).round(0) }
    end
  end
  result
end
