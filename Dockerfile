FROM node:lts

RUN mkdir -p /usr/src/app && \
    chown -R node:node /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y jq

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

COPY --chown=node:node install/package.json /usr/src/app/package.json

USER node

RUN npm install && \
    npm cache clean --force

COPY --chown=node:node . /usr/src/app

ENV NODE_ENV=production \
    daemon=false \
    silent=false

EXPOSE 4567

COPY --chown=node:node create_config.sh /usr/src/app/create_config.sh
COPY --chown=node:node config_template.json /usr/src/app/config_template.json

CMD  ./usr/src/app/create_config.sh -n "${SETUP}" && ./nodebb setup || node ./nodebb build; node ./nodebb start

