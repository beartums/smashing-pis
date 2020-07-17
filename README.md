Dashboard(s) for showing status of SBC servers
Temperature, cpu usage, and external IP addresses

To ssetup:
# clone && cd smashing-pis
# docker-compose run --rm --service-ports runner
# bundle install
# create .env file in roote with server json {"name":, "user_id":, "ip":, "password":)}
(process not actually tested)

Check out http://smashing.github.io/smashing for more information.
