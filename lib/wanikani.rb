# frozen_string_literal: true

class Wanikani
  include HTTParty

  TARGET_API_VERSION = "v1.4"
  base_uri "www.wanikani.com"

  def initialize(api_key)
    @api_key = api_key
  end

  def get(path)
    self.class.get "/api/#{TARGET_API_VERSION}/user/#{@api_key}/#{path.remove(/^\//)}"
  end
end
