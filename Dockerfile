FROM node:8-alpine

ENV NODE_ENV production

# Enable chokidar polling so hot-reload mechanism can work on docker or network volumes
ENV CHOKIDAR_USEPOLLING true

ENV EG_CONFIG_DIR /var/lib/eg

WORKDIR /usr/src/app

COPY package.json package-lock.json /usr/src/app/
RUN npm install


COPY docker-entrypoint.sh /usr/src/app/
RUN chmod 755 docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8080 9876

CMD [ "node", "lib", "index.js" ]

COPY . /usr/src/app










