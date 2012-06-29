require 'httparty'
require 'cgi'
require 'json'

class GCM
  include HTTParty
  default_timeout 30

  attr_accessor :timeout, :api_key

  PUSH_URL = 'https://android.googleapis.com/gcm/send'

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
  def send_notification(registration_ids, options)
    post_body = self.class.build_post_body(registration_ids, options)

    params = {
      :body    => post_body,
      :headers => {
        'Authorization'  => "key=#{@api_key}",
        'Content-type'   => 'application/json',
      }
    }

    self.class.post(PUSH_URL, params)
  end

  private

  def build_post_body(registration_ids, options={})
    body = {}
    #raise exception if options[:time_to_live] && !options[:collapse_key]
  end

end
