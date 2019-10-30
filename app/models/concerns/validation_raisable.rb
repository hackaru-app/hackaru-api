# frozen_string_literal: true

module ValidationRaisable
  def valid!
    raise ActiveRecord::RecordInvalid, self if invalid?
  end
end
