FROM jenkins/jenkins as t4d-jenkins
USER root

# Install docker
RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates curl software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
RUN apt-get update
RUN apt-get install -y docker-ce

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
