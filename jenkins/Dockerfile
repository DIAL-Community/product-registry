FROM jenkins/jenkins as t4d-jenkins
USER root

# Install docker machine
RUN wget -P /tmp https://github.com/docker/machine/releases/download/v0.14.0/docker-machine-$(uname -s)-$(uname -m)
RUN mv /tmp/docker-machine-Linux-x86_64 /tmp/docker-machine
RUN chmod +x /tmp/docker-machine
RUN mv /tmp/docker-machine /usr/local/bin
RUN docker-machine version

# Install docker compose
RUN apt-get update
RUN apt-get install -y python-pip
RUN apt-get install -y python-dev libffi-dev gcc libc-dev make
RUN pip install docker-compose

VOLUME /var/jenkins_home