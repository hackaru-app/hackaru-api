FROM ruby:2.6.4-alpine3.10 as builder
ENV API_DIR /hackaru
WORKDIR $API_DIR
RUN apk -U upgrade \
 && apk add --update --no-cache -t build-dependencies \
    build-base \
    postgresql-dev
COPY Gemfile Gemfile.lock $API_DIR/
RUN bundle install -j4


FROM ruby:2.6.4-alpine3.10
ENV API_DIR /hackaru
WORKDIR $API_DIR
COPY --from=builder /usr/local/bundle /usr/local/bundle
RUN apk -U upgrade \
 && apk add --update --no-cache \
    tzdata \
    postgresql-client \
 && addgroup hackaru \
 && adduser -s /bin/sh -D -G hackaru hackaru \
 && chown hackaru:hackaru $API_DIR
COPY --chown=hackaru:hackaru . $API_DIR
USER hackaru
CMD ["rails", "s", "-b", "0.0.0.0"]
