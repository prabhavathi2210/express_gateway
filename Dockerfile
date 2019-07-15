FROM node:8-alpine

ENV NODE_ENV production


ENV CHOKIDAR_USEPOLLING true

RUN npm install mkdirp --local

RUN mkdir -p /var/lib/eg

ENV EG_CONFIG_DIR /var/lib/eg
VOLUME /var/lib/eg
COPY ./bin/generators/gateway/templates/basic/config /var/lib/eg
COPY ./lib/config/models /var/lib/eg/models


WORKDIR /usr/src/app

COPY package.json package-lock.json /usr/src/app/

RUN npm install

EXPOSE 8080 9876

CMD [ "node", "lib", "index.js" ]

COPY . /usr/src/app
