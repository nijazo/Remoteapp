FROM ubuntu:noble

EXPOSE 5000

ENV ASPNETCORE_ENVIRONMENT="Production"
ENV ASPNETCORE_URLS="http://*:5000"

RUN \
  apt-get -y update && \
  apt-get -y install \
  apt-utils \
  wget \
  apt-transport-https \
  unzip \
  acl \
  libssl3

RUN \
  wget -q https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb && \
  dpkg -i packages-microsoft-prod.deb && \
  apt-get -y update && \
  apt-get -y install aspnetcore-runtime-9.0

RUN \
  mkdir -p /var/www/remoteapp && \
  mkdir /config && \
  wget -q https://github.com/nijazo/Remoteapp/releases/latest/download/Remoteapp_Server_Linux-x64.zip && \
  unzip -o Remoteapp_Server_Linux-x64.zip -d /var/www/remoteapp && \
  rm Remoteapp_Server_Linux-x64.zip

RUN \
  mkdir -p /remoteapp-data && \
  sed -i 's/DataSource=Remoteapp.db/DataSource=\/remoteapp-data\/Remoteapp.db/' /var/www/remoteapp/appsettings.json && \
  sed -i 's/"ServerUrl":  ""/"ServerUrl":  "https:\/\/remoteapp.nl"/' /var/www/remoteapp/appsettings.json

VOLUME "/remoteapp-data"

WORKDIR /var/www/remoteapp

COPY DockerMain.sh /

RUN chmod 755 /DockerMain.sh

ENTRYPOINT ["/DockerMain.sh"]
