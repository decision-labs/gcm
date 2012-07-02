require 'httparty'
require 'cgi'
require 'json'

class GCM
  include HTTParty
  PUSH_URL = 'https://android.googleapis.com/gcm/send'
  base_uri PUSH_URL
  default_timeout 30
  format :json

  attr_accessor :timeout, :api_key

  def initialize(api_key)
    @api_key = api_key
  end

  # {
  #   "collapse_key": "score_update",
  #   "time_to_live": 108,
  #   "delay_while_idle": true,
  #   "registration_ids": ["4", "8", "15", "16", "23", "42"],
  #   "data" : {
  #     "score": "5x1",
  #     "time": "15:10"
  #   }
  # }
  # gcm = GCM.new(api_key)
  # gcm.send_notification({registration_ids: ["4sdsx", "8sdsd"], data: {score: "5x1"}})
  def send_notification(registration_ids, options = {})
    post_body = build_post_body(registration_ids, options)

    params = {
      :body    => post_body.to_json,
      :headers => {
        'Authorization'  => "key=#{@api_key}",
        'Content-Type'   => 'application/json',
      }
    }

    response = self.class.post('', params)
    {body: response.body, headers: response.headers, status: response.code}
  end

  private

  def build_post_body(registration_ids, options={})
    body = {registration_ids: registration_ids}.merge(options)
    #raise exception if options[:time_to_live] && !options[:collapse_key]
  end

end
