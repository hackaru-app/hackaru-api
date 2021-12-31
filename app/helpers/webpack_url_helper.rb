# frozen_string_literal: true

module WebpackUrlHelper
  MANIFEST_PATH = 'public/packs/manifest.json'
  private_constant :MANIFEST_PATH

  def webpack_url(path)
    asset_url(manifest.fetch(path.to_s))
  end

  private

  def manifest
    @manifest ||= JSON.parse(File.read(MANIFEST_PATH))
  end
end
