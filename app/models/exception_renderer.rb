# frozen_string_literal: true

class ExceptionRenderer < ErrorRenderer
  def initialize(exception)
    super exception.class.name.gsub(/::/, '.').underscore
    @exception = exception
    @message = validation_error? ? validation_message : translate[:message]
  end

  private

  def scope
    :exception_renderer
  end

  def validation_error?
    @key == 'active_record.record_invalid'
  end

  def validation_message
    @exception.record.errors.full_messages.first
  end
end
