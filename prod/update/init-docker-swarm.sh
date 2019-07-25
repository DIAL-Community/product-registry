docker run -d -p 5000:5000 --restart=always --name registry registry:2
docker swarm init

read -p "Please enter new version number: " version_number
export T4D_VERSION=$version_number
docker-compose -f ../../docker-compose.yml build
docker-compose -f ../../docker-compose.yml push
docker stack deploy --compose-file ../../docker-compose.yml t4d-app
sleep 60s

docker service scale t4d-app_web=2
