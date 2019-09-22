# frozen_string_literal: true

module EmailHelper
  def email_image_url(image, dir = 'app/assets/images')
    attachments[image] = File.read Rails.root.join("#{dir}/#{image}")
    attachments[image].url
  end

  def utm_url(url)
    uri = URI.parse(url)
    uri.query = join_utm_params(uri.query)
    uri.to_s
  end

  private

  def join_utm_params(query)
    query = Hash[URI.decode_www_form(query.to_s)].merge(utm_params)
    URI.encode_www_form(query)
  end

  def utm_params
    {
      utm_medium: :email,
      utm_source: controller_path,
      utm_campaign: action_name
    }
  end
end
