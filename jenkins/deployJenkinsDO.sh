docker -v && docker-compose -v && docker-machine -v

export DOTOKEN=0881761c66786419bee57c6438f14265a5391bba02ad531d5ed9aa649376c2d7
 
# set-up: clean up any previous machine failures
docker-machine stop t4d-jenkins || echo "nothing to stop" && \
docker-machine rm -y t4d-jenkins   || echo "nothing to remove"
 
# use docker-machine to create and configure environment
docker-machine create --driver digitalocean --digitalocean-access-token $DOTOKEN --digitalocean-size 2gb t4d-jenkins
eval $(docker-machine env --shell sh t4d-jenkins)
 
# build
docker build -t t4d/jenkins .

docker run -d --name jenkins -p 80:8080 -p 50000:50000 t4d/jenkins

docker logs jenkins

echo "Navigate to Jenkins instance and set up admin user with credentials t4d/t4d"