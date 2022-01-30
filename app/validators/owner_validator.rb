# frozen_string_literal: true

class OwnerValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    owner = options[:model]
    record.errors.add(attribute, :invalid_owner) unless valid?(owner, record, value)
  end

  private

  def valid?(owner, record, value)
    return false if owner.blank?
    return false if value&.send(owner).blank?
    return false if record.send(owner) != value.send(owner)

    true
  end
end
