FROM ruby:3.0.3-alpine3.13 as bundler
ENV API_DIR /hackaru
WORKDIR $API_DIR
RUN apk -U upgrade \
 && apk add --update --no-cache -t build-dependencies \
    build-base \
    postgresql-dev
COPY Gemfile Gemfile.lock $API_DIR/
RUN bundle install -j4

FROM node:18.5.0-alpine as node
ENV API_DIR /hackaru
WORKDIR $API_DIR
COPY package.json \
  yarn.lock \
  webpack.common.js \
  webpack.prod.js \
  $API_DIR/
COPY /app/assets $API_DIR/app/assets
RUN yarn && yarn build

FROM ruby:3.0.3-alpine3.13
ENV API_DIR /hackaru
WORKDIR $API_DIR
RUN apk -U upgrade \
 && apk add --update --no-cache \
    tzdata \
    postgresql-client \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    less \
    yarn
COPY --from=node \
    /usr/local/bin/node \
    /usr/local/bin/node
COPY --from=bundler \
    /usr/local/bundle \
    /usr/local/bundle
COPY --from=node \
    $API_DIR/node_modules \
    $API_DIR/node_modules
COPY --from=node \
    $API_DIR/public/packs \
    $API_DIR/public/packs
RUN addgroup hackaru \
 && adduser -s /bin/sh -D -G hackaru hackaru \
 && chown hackaru:hackaru $API_DIR
COPY --chown=hackaru:hackaru . $API_DIR
USER hackaru
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
