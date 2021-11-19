# hackaru-api

The API server for Hackaru.  
An open source and simple time tracking app.

[![Maintainability](https://api.codeclimate.com/v1/badges/5dedffcfb6bc88f0d799/maintainability)](https://codeclimate.com/github/hackaru-app/hackaru-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5dedffcfb6bc88f0d799/test_coverage)](https://codeclimate.com/github/hackaru-app/hackaru-api/test_coverage)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

## Features

Want to know that you can do with Hackaru?  
For more information on the app, please see the main repository [README](https://github.com/hackaru-app/hackaru).

## Roles

The API server provides REST API to web server and desktop app.

## Feedback

Do you find a bug or would like to submit feature requests?  
Please let us know via [Issues](https://github.com/hackaru-app/hackaru/issues). 😉

## Quickstart

You can run Hackaru on your local easily using [docker-compose](https://docs.docker.com/compose/install).

It's also necessary to run the web server if you want to login to Hackaru on your browser.  
Please see the web server [README](https://github.com/hackaru-app/hackaru-web).

```sh
# Clone this repository.
git clone git@github.com:hackaru-app/hackaru-api.git
cd hackaru-api

# Copy and rename env file.
cp .env.sample .env.development

# Set up the database, build assets, etc.
docker-compose -f docker-compose.yml -f docker-compose.dev.yml run api bin/setup

# Try accessing http://localhost:3000 after execution.
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
```

## License

- [MIT](./LICENSE)
