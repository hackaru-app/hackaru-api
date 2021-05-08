# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base
  fields :id
  fields :time_zone
  fields :locale
  fields :receive_week_report
  fields :receive_month_report

  view :auth do
    fields :email
  end
end
