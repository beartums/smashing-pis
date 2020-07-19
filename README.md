# Smashing Pis
## Smashing Dashboard(s) for showing status of SBC servers

Temperature, cpu usage, and external IP addresses

To setup:

- clone && cd smashing-pis
- create .env file in root with server json {"name":, "user_id":, "ip":, "password":)}
- docker-compose run --rm --service-ports runner
- bundle install
- install `sysstat` on your servers (if you want cpu activity to be reported)
(process not actually tested)

Check out http://smashing.github.io/smashing for more information about the framework.
