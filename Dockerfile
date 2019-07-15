FROM node:8-alpine

ENV NODE_ENV production

# Enable chokidar polling so hot-reload mechanism can work on docker or network volumes
ENV CHOKIDAR_USEPOLLING true

ENV EG_CONFIG_DIR /usr/src/app/lib/config



COPY package.json package-lock.json /usr/src/app/

RUN chmod +x docker-entrypoint.sh

COPY ./docker-entrypoint.sh /usr/src/app/

WORKDIR /usr/src/app

RUN chmod +x /usr/src/app/docker-entrypoint.sh

ENTRYPOINT ["/usr/src/app/docker-entrypoint.sh"]


RUN npm install

EXPOSE 8080 9876

CMD [ "node", "lib", "index.js" ]


















