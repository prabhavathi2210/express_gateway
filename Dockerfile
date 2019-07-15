FROM node:8-alpine

ENV NODE_ENV production

ARG EG_VERSION

ENV NODE_PATH /usr/local/share/.config/yarn/global/node_modules/

ENV CHOKIDAR_USEPOLLING true

RUN npm install mkdirp

RUN MKDIR -p /var/lib/eg

ENV EG_CONFIG_DIR /var/lib/eg



VOLUME /var/lib/eg
RUN yarn global add express-gateway@$EG_VERSION

COPY ./bin/generators/gateway/templates/basic/config /var/lib/eg
COPY ./lib/config/models /var/lib/eg/models

COPY . /usr/src/app

WORKDIR /usr/src/app


COPY package.json package-lock.json /usr/src/app/
RUN npm install

EXPOSE 8080 9876

CMD [ "node", "lib", "index.js" ]





