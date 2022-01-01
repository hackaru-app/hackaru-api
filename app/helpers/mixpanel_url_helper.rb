# frozen_string_literal: true

module MixpanelUrlHelper
  MIXPANEL_URL = 'https://api.mixpanel.com'
  private_constant :MIXPANEL_URL

  def mixpanel_pixel_url(event, props)
    data = { event: event, properties: props }
    url = URI.parse(MIXPANEL_URL)
    url.path = '/track'
    url.query = build_query(data)
    url.to_s
  end

  private

  def build_query(data)
    params = { data: build_encoded_data(data), img: 1 }
    URI.encode_www_form(params)
  end

  def build_encoded_data(data)
    json = data.deep_merge(required_data).to_json
    Base64.urlsafe_encode64(json)
  end

  def required_data
    token = ENV.fetch('MIXPANEL_PROJECT_TOKEN', '')
    { properties: { token: token, repository: 'hackaru-api' } }
  end
end
