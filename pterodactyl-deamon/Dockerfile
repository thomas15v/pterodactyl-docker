FROM node

WORKDIR /srv/daemon

RUN apt update && apt install -y tar unzip make gcc g++ python-minimal
RUN wget https://github.com/Pterodactyl/Daemon/archive/v0.3.7.tar.gz \
 && tar --strip-components=1 -xzvf v0.3.7.tar.gz \
 && npm install --production


VOLUME ["srv/daemon-data/]

EXPOSE 8080

CMD ["npm", "start"]