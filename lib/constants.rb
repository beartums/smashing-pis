module Constants
  SERVERS = JSON.parse(ENV['SERVERS'])
  RPI_TEMPERATURE_COMMAND = 'cat /sys/class/thermal/thermal_zone*/temp'
end
  

