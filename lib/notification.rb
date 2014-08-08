require 'httparty'
require 'cgi'
require 'json'

class Notification
  include HTTParty
  NOTIFICATION_URL = 'https://android.googleapis.com/gcm/notification'
  base_uri NOTIFICATION_URL
  default_timeout 30
  format :json

  attr_accessor :timeout, :api_key, :project_id

  def initialize(api_key, project_id, client_options = {})
    @api_key = api_key
    @project_id = project_id
    @client_options = client_options
  end

  def create_key(key_name, registration_ids=[])
    post_body =   { :operation => "create",
                    :notification_key_name => key_name,
                    :registration_ids => registration_ids
                  }
    params = {
      :body => post_body.to_json,
      :headers => {
        'Content-Type' => 'application/json',
        'project_id' => @project_id,
        'Authorization' => "key=#{@api_key}"
      }
    }

    response = self.class.post('', params.merge(@client_options))
    build_response(response)
  end

  def add_registration_ids(key_name, registration_ids, notification_key)
    post_body =   { :operation => "add",
                    :notification_key_name => key_name,
                    :registration_ids => registration_ids,
                    :notification_key => notification_key
                  }
    params = {
      :body => post_body.to_json,
      :headers => {
        'Content-Type' => 'application/json',
        'project_id' => @project_id,
        'Authorization' => "key=#{@api_key}"
      }
    }

    response = self.class.post('', params.merge(@client_options))
    build_response(response)
  end

  def remove_registration_ids(key_name, registration_ids, notification_key)
    post_body =   { :operation => "remove",
                    :notification_key_name => key_name,
                    :registration_ids => registration_ids,
                    :notification_key => notification_key
                  }
    params = {
      :body => post_body.to_json,
      :headers => {
        'Content-Type' => 'application/json',
        'project_id' => @project_id,
        'Authorization' => "key=#{@api_key}"
      }
    }

    response = self.class.post('', params.merge(@client_options))
    build_response(response)
  end

  def build_response(response)
    body = response.body || {}
    response_hash = {:body => body, :headers => response.headers, :status_code => response.code}
    case response.code
      when 200
        response_hash[:response] = 'success'
      when 503
        response_hash[:response] = 'failure'
    end
    response_hash
  end
end
