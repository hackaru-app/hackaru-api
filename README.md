[![code style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg?style=flat-square)](https://github.com/prettier/prettier)
[![Build Status](https://travis-ci.org/ktmouk/hackaru-api.svg?branch=master)](https://travis-ci.org/ktmouk/hackaru-api)
[![codecov](https://codecov.io/gh/hackaru-app/hackaru-api/branch/master/graph/badge.svg)](https://codecov.io/gh/hackaru-app/hackaru-api)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

<br>
<p align="center">
  <p align="center"><img src="./docs/images/architecture.png" width="500" /></p>
  <p align="center">Hackaru API</p>
  <p align="center">Provide RESTful API and OAuth2.</p>
</p>

## Contributing
1. Install [docker-compose](https://docs.docker.com/compose/install/) and [bundler](https://bundler.io/).
1. [Fork](https://github.com/ktmouk/hackaru-apu/fork) and clone this repository.
1. Check out new branch. `git checkout -b new-feature`
1. Copy env file from the sample file. `cp .env.sample .env.development`
1. Setup server. `docker-compose -f docker-compose.yml -f docker-compose.dev.yml run --rm api bin/setup`
1. Start dev server. `docker-compose -f docker-compose.yml -f docker-compose.dev.yml up`
1. Improve codes.
1. Run rubocop and brakeman. `bundle && bundle exec rubocop && bundle exec brakeman`
1. Run test. `docker-compose -f docker-compose.test.yml run sut`
1. Create a new pull request.

## License

- [MIT](./LICENSE)
