module Constants
  SERVERS = JSON.parse(ENV['SERVERS'])
  
  CPU_WIDGET_SUFFIX = '_cpu'
  TEMP_WIDGET_SUFFIX = '_temp'

  RPI_TEMP_MILLICELSIUS_COMMAND = 'cat /sys/class/thermal/thermal_zone*/temp'

  # requires sysstat
  RPI_IDLE_CPU_PERCENT_COMMAND =  "sar -f -u -s $(date --date=\"@$(($(date +%s)-60))\" +%H:%M:%S) -e $(date +%H:%M:%S) | grep Average | awk '{ print $8 }'"


  MPSTAT_CPU_IDLE = "mpstat -u 1 1| awk '{ if ($2==\"all\" || $3==\"all\") {print $NF}}'"
  TOP_CPU_IDLE = "top -b -n 1 | grep %Cpu\(s\) | awk '{print $8}'"
  
  # all below require sysstat
  IOSTAT_CPU_IDLE = "iostat -c 1 2 | sed -n 8p | awk '{ print $6}'"
  START_SAR = "sudo sar -o -u 20  >/dev/null 2>&1 &"
  SAR_CPU_STATS_60S = "sar -f -u -s $(date --date=\"@$(($(date +%s)-60))\" +%H:%M:%S) -e $(date +%H:%M:%S)"
  SAR_CPU_STATS_OBJ_FORMAT = " | sed -r -n '/(%|Average)/p' | sed -r ' s/\s{2,}/,/g'"
  SAR_CPU_STATS_CPU_IDLE = "sar -f -u -s $(date --date=\"@$(($(date +%s)-60))\" +%H:%M:%S) -e $(date +%H:%M:%S) | grep Average | awk '{ print $8 }'"

end
  

