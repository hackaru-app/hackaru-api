# Hackaru API

[![Maintainability](https://api.codeclimate.com/v1/badges/95e37cce5262a1c83fa5/maintainability)](https://codeclimate.com/github/ktmouk/hackaru-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/95e37cce5262a1c83fa5/test_coverage)](https://codeclimate.com/github/ktmouk/hackaru-api/test_coverage)

Serve API and OAuth2 authentication.

## Usage

See [ktmouk/hackaru](https://github.com/ktmouk/hackaru)

## Contributors

1. [Fork it](https://github.com/ktmouk/hackaru-api/fork).

2. Install [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

3. Clone forked repository and create new branch.
```
$ git checkout -b new-feature
```

4. Improve codes.

5. Run [RoboCop](https://github.com/rubocop-hq/rubocop), [Brakeman](https://github.com/presidentbeef/brakeman) and [RSpec](https://github.com/rspec/rspec).
```
$ docker-compose -f docker-compose.test.yml run rubocop rubocop -a
$ docker-compose -f docker-compose.test.yml run brakeman
$ docker-compose -f docker-compose.test.yml run rspec
```

6. If has no problem, Create new Pull request!

## License

- [MIT](./LICENSE)
