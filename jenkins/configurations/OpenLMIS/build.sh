cp settings-sample.env settings.env

docker -v && docker-compose -v && docker-machine -v

MACHINE_NAME=$ORG_ID"-openlmis"
 
# set-up: clean up any previous machine failures
docker-machine stop $MACHINE_NAME || {
  docker-machine rm -y $MACHINE_NAME || echo "Nothing to destroy"
  echo "creating new container"
  if [$PROVIDER == "DO"]; then
  	docker-machine create --driver digitalocean --digitalocean-access-token $AUTH_TOKEN --digitalocean-size 8gb $MACHINE_NAME
  else
  	docker-machine create --driver amazonec2 --amazonec2-access-key $AUTH_TOKEN --amazonec2-secret-key $SECRET_KEY $MACHINE_NAME
  fi
}
 
# use docker-machine to create and configure 'test' environment
# add a -D (debug) if having issues
docker-machine start $MACHINE_NAME || echo "container started"

IPADDRESS="$(docker-machine ip $MACHINE_NAME)"

sed -i "s/^BASE_URL=.*/BASE_URL=http:\/\/$IPADDRESS/" settings.env
sed -i "s/^VIRTUAL_HOST=.*/VIRTUAL_HOST=$IPADDRESS/" settings.env

eval $(docker-machine env --shell sh $MACHINE_NAME)
 
# build
docker-compose pull

docker-compose up -d

# The last line of the build output should always be the docker-machine IP
# This will be used by the T4D app to give the user a link

echo "openlmis instance"
docker-machine ip $MACHINE_NAME