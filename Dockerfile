FROM node:8-alpine

ENV NODE_ENV production

ENV CHOKIDAR_USEPOLLING true

ENV EG_CONFIG_DIR /usr/src/app/lib/config

VOLUME /var/lib/eg

COPY package.json package-lock.json /usr/src/app/

COPY ./docker-entrypoint.sh /usr/src/app/

WORKDIR /usr/src/app

COPY ./lib/config/models /var/lib/eg/models

COPY package.json package-lock.json /usr/src/app/
COPY ./docker-entrypoint.sh /usr/src/app/


RUN chmod +x /usr/src/app/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

RUN npm install 

EXPOSE 8080 9876

CMD [ "node", "lib", "index.js" ]

COPY . /usr/src/app










