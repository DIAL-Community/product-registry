export POSTGRES_OPENSRP_TABLESPACE_DIR=/opt/postgresql
export POSTGRES_OPENSRP_DATABASE=opensrp
export POSTGRES_OPENSRP_USER=opensrp_admin
export POSTGRES_OPENSRP_PASSWORD=admin
export MYSQL_ROOT_PASSWORD=mypassword
export MYSQL_MOTECH_DATABASE=motechquartz
export MYSQL_REPORTING_DATABASE=report
export MYSQL_ANM_DATABASE=anm
export MYSQL_OPENMRS_USER=openmrs
export MYSQL_OPENMRS_PASSWORD=openmrs
export MYSQL_OPENMRS_DATABASE=openmrs
export MYSQL_OPENSRP_USER=opensrp
export MYSQL_OPENSRP_PASSWORD=opensrp
export MYSQL_OPENSRP_DATABASE=opensrp
export COUCHDB_USER=rootuser
export COUCHDB_PASSWORD=adminpass
export REDIS_PASSWORD=reallylongreallylongpassword
export OPENSRP_SERVER_TAG=master

cd composed

docker -v && docker-compose -v && docker-machine -v

MACHINE_NAME=$ORG_ID"-opensrp"
 
# set-up: clean up any previous machine failures
docker-machine stop $MACHINE_NAME || {
  docker-machine rm -y $MACHINE_NAME || echo "Nothing to destroy"
  docker-machine create --driver digitalocean --digitalocean-access-token $AUTH_TOKEN --digitalocean-size 4gb $MACHINE_NAME
}
 
# use docker-machine to create and configure 'test' environment
# add a -D (debug) if having issues
docker-machine start $MACHINE_NAME || echo "container started"

IPADDRESS="$(docker-machine ip $MACHINE_NAME)"

eval $(docker-machine env --shell sh $MACHINE_NAME)
 
docker-compose pull
docker-compose up -d

# The last line of the build output should always be the docker-machine IP
# This will be used by the T4D app to give the user a link

echo "OpenSRP instance: "
docker-machine ip $MACHINE_NAME