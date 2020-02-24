# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id
  attributes :email
  attributes :time_zone
  attributes :locale
  attributes :receive_week_report
  attributes :receive_month_report
  attributes :receive_reminder
end
