# Hackaru API

[![Maintainability](https://api.codeclimate.com/v1/badges/95e37cce5262a1c83fa5/maintainability)](https://codeclimate.com/github/ktmouk/hackaru-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/95e37cce5262a1c83fa5/test_coverage)](https://codeclimate.com/github/ktmouk/hackaru-api/test_coverage)

Serve API and OAuth2 authentication.

## Usage

See [ktmouk/hackaru](https://github.com/ktmouk/hackaru)

## Contributors

1. Install [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

2. Clone this repository and checkout.
```
$ git clone https://github.com/ktmouk/hackaru-api.git
$ cd /hackaru
$ git checkout -b YOUR_BRANCH
```

3. Improve code.

4. Run [RoboCop](https://github.com/rubocop-hq/rubocop) and [Brakeman](https://github.com/presidentbeef/brakeman).
```
$ docker-compose -f docker-compose.test.yml run rubocop rubocop -a
$ docker-compose -f docker-compose.test.yml run brakeman
```

5. Run [RSpec](https://github.com/rspec/rspec).
```
$ docker-compose -f docker-compose.test.yml run rspec
```

6. If has no problem, push your branch! :tada:
```
$ git push origin YOUR_BRANCH
```


## License

- [MIT](./LICENSE)
