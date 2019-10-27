# frozen_string_literal: true

module ValidationRaisable
  def valid!
    raise ActiveRecord::RecordInvalid.new(self) if invalid?
  end
end
