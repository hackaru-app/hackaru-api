# frozen_string_literal: true

class ErrorRenderer
  attr_reader :message, :status

  def initialize(key)
    @key = key
    @message = translate[:message]
    @status = translate[:status]
  end

  private

  def scope
    :error_renderer
  end

  def translate
    I18n.t(@key, scope: scope, default: :default)
  end
end
