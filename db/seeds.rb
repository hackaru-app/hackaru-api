# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

return if Rails.env.production?

Doorkeeper::Application.find_or_create_by!(uid: 'client_id') do |application|
  application.name = 'Hackaru for desktop'
  application.confidential = false
  application.redirect_uri = 'http://127.0.0.1'
  application.scopes = [
    'activities:read',
    'activities:write',
    'projects:read',
    'projects:write',
    'suggestions:read',
    'user:read'
  ].join(' ')
end
