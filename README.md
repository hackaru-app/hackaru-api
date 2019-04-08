# Hackaru API

[![Build Status](https://travis-ci.org/ktmouk/hackaru-web.svg?branch=master)](https://travis-ci.org/ktmouk/hackaru-web)
[![Maintainability](https://api.codeclimate.com/v1/badges/95e37cce5262a1c83fa5/maintainability)](https://codeclimate.com/github/ktmouk/hackaru-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/95e37cce5262a1c83fa5/test_coverage)](https://codeclimate.com/github/ktmouk/hackaru-api/test_coverage)

Serve API and OAuth2 authentication.

## Usage

See [ktmouk/hackaru](https://github.com/ktmouk/hackaru)

## Contributors

1. [Fork it](https://github.com/ktmouk/hackaru-api/fork).

2. Install [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

3. Clone a forked repository and create a new branch.
```
$ git checkout -b new-feature
```

4. Improve codes.

5. Run [RoboCop](https://github.com/rubocop-hq/rubocop), [Brakeman](https://github.com/presidentbeef/brakeman), and [RSpec](https://github.com/rspec/rspec).
```
$ bundle install
$ bundle exec rubocop -a
$ bundle exec brakeman
$ docker-compose -f docker-compose.test.yml run sut
```

6. If it has no problem, Create a new Pull request!

## License

- [MIT](./LICENSE)
