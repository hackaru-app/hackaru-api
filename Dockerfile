FROM ruby:2.7.0-alpine3.10 as bundler
ENV API_DIR /hackaru
WORKDIR $API_DIR
RUN apk -U upgrade \
 && apk add --update --no-cache -t build-dependencies \
    build-base \
    postgresql-dev
COPY Gemfile Gemfile.lock $API_DIR/
RUN bundle install -j4

FROM node:13-alpine as node
ENV API_DIR /hackaru
WORKDIR $API_DIR
COPY package.json yarn.lock $API_DIR/
RUN yarn

FROM ruby:2.7.0-alpine3.10
ENV API_DIR /hackaru
WORKDIR $API_DIR
COPY --from=bundler \
    /usr/local/bundle \
    /usr/local/bundle
COPY --from=node \
    /hackaru/node_modules \
    /hackaru/node_modules
COPY --from=node \
    /usr/local/bin/node \
    /usr/local/bin/node
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
    yarn \
 && addgroup hackaru \
 && adduser -s /bin/sh -D -G hackaru hackaru \
 && chown hackaru:hackaru $API_DIR
COPY --chown=hackaru:hackaru . $API_DIR
USER hackaru
RUN /hackaru/bin/webpack
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
