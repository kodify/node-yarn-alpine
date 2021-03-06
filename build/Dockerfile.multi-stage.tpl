FROM node:${NODE_VERSION}-alpine as build

RUN mkdir -p /app

WORKDIR /app

ONBUILD COPY package.json /app/
ONBUILD COPY yarn.lock /app/

ONBUILD RUN yarn install && yarn cache clean

ONBUILD COPY . /app

ONBUILD RUN yarn build \
&& rm -rf node_modules \
&& yarn install --production

FROM node:${NODE_VERSION}-alpine

RUN mkdir -p /app

WORKDIR /app

ONBUILD COPY --from=build package.json /app
ONBUILD COPY --from=build . /app

CMD [ "npm", "start" ]