# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w[
  normalize.css/normalize.css
  mailer.scss
  pdf.scss
  c3/c3.min.css
  c3/c3.min.js
  d3/dist/d3.min.js
  report.js
]
