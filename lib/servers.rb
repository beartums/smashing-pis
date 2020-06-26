module Servers
  SERVERS = [
    {
      name: 'grifMedia',
      ip: '192.168.0.25' 
    },
    {
      name: 'grifGateway',
      ip: '192.168.0.24'
    }
  ]

  RPI_TEMPERATURE_COMMAND = 'cat /sys/class/thermal/thermal_zone*/temp'

  def readable_temperature(temp, format = 'F') 
    temp / 1000 if format != 'F'
    (temp / 1000) * (9/5) + 32
  end
end
  

