# frozen_string_literal: true

module EmailHelper
  def email_image_tag(image, options = {})
    image_tag email_image_url(image), options
  end

  private

  def email_image_url(image)
    attachments[image] = File.read Rails.root.join("app/assets/images/#{image}")
    attachments[image].url
  end
end
