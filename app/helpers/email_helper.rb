# frozen_string_literal: true

module EmailHelper
  def email_image_url(image, dir = 'app/assets/images')
    attachments[image] = File.read Rails.root.join("#{dir}/#{image}")
    attachments[image].url
  end
end
