# frozen_string_literal: true

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
