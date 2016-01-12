require 'httparty'
require 'cgi'
require 'json'

class GCM
  include HTTParty
  base_uri 'https://android.googleapis.com/gcm'
  default_timeout 30
  format :json

  attr_accessor :timeout, :api_key

  def initialize(api_key, client_options = {})
    @api_key = api_key
    @client_options = client_options
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
  # gcm = GCM.new("API_KEY")
  # gcm.send(registration_ids: ["4sdsx", "8sdsd"], {data: {score: "5x1"}})
  # gcm.send(registration_ids: ["4sdsx", "8sdsd"], {data: {score: "5x1"}}, 'topics')
  def send_notification(registration_ids, options = {}, to='registration_ids')
    post_body = build_post_body(registration_ids, options, to)

    params = {
      :body => post_body.to_json,
      :headers => {
        'Authorization' => "key=#{@api_key}",
        'Content-Type' => 'application/json',
      }
    }
    response = self.class.post('/send', params.merge(@client_options))
    build_response(response, registration_ids)
  end
  alias_method :send, :send_notification

  def create_notification_key(key_name, project_id, registration_ids=[])
    post_body = build_post_body(registration_ids, {
                  :operation => "create",
                  :notification_key_name => key_name})

    params = {
      :body => post_body.to_json,
      :headers => {
        'Content-Type' => 'application/json',
        'project_id' => project_id,
        'Authorization' => "key=#{@api_key}"
      }
    }

    response = self.class.post('/notification', params.merge(@client_options))
    build_response(response)
  end
  alias_method :create, :create_notification_key

  def add_registration_ids(key_name, project_id, notification_key, registration_ids)
    post_body = build_post_body(registration_ids, {
                    :operation => "add",
                    :notification_key_name => key_name,
                    :notification_key => notification_key})

    params = {
      :body => post_body.to_json,
      :headers => {
        'Content-Type' => 'application/json',
        'project_id' => project_id,
        'Authorization' => "key=#{@api_key}"
      }
    }

    response = self.class.post('/notification', params.merge(@client_options))
    build_response(response)
  end
  alias_method :add, :add_registration_ids

  def remove_registration_ids(key_name, project_id, notification_key, registration_ids)
    post_body = build_post_body(registration_ids, {
                  :operation => "remove",
                  :notification_key_name => key_name,
                  :notification_key => notification_key})

    params = {
      :body => post_body.to_json,
      :headers => {
        'Content-Type' => 'application/json',
        'project_id' => project_id,
        'Authorization' => "key=#{@api_key}"
      }
    }

    response = self.class.post('/notification', params.merge(@client_options))
    build_response(response)
  end
  alias_method :remove, :remove_registration_ids

  def send_with_notification_key(notification_key, options)
    body = { :to => notification_key }.merge(options)

    params = {
      :body => body.to_json,
      :headers => {
        'Authorization' => "key=#{@api_key}",
        'Content-Type' => 'application/json',
      }
    }
    response = self.class.post('/send', params.merge(@client_options))
    build_response(response)
  end

  private

  def build_post_body(registration_ids, options={}, to)
    case to
    when 'topics'
      { :to => registration_ids }.merge(options)
    else
      { :registration_ids => registration_ids }.merge(options)
    end
  end

  def build_response(response, registration_ids=[])
    body = response.body || {}
    response_hash = {:body => body, :headers => response.headers, :status_code => response.code}
    case response.code
      when 200
        response_hash[:response] = 'success'
        body = JSON.parse(body) unless body.empty?
        response_hash[:canonical_ids] = build_canonical_ids(body, registration_ids) if is_array(registration_ids) && !registration_ids.empty?
        response_hash[:not_registered_ids] = build_not_registered_ids(body,registration_ids) if is_array(registration_ids) && !registration_ids.empty?
      when 400
        response_hash[:response] = 'Only applies for JSON requests. Indicates that the request could not be parsed as JSON, or it contained invalid fields.'
      when 401
        response_hash[:response] = 'There was an error authenticating the sender account.'
      when 503
        response_hash[:response] = 'Server is temporarily unavailable.'
      when 500..599
        response_hash[:response] = 'There was an internal error in the GCM server while trying to process the request.'
    end
    response_hash
  end

  def build_canonical_ids(body, registration_ids)
    canonical_ids = []
    unless body.empty?
      if body['canonical_ids'] > 0
        body['results'].each_with_index do |result, index|
          canonical_ids << { :old => registration_ids[index], :new => result['registration_id'] } if has_canonical_id?(result)
        end
      end
    end
    canonical_ids
  end

  def build_not_registered_ids(body, registration_id)
    not_registered_ids = []
    unless body.empty?
      if body['failure'] > 0
        body['results'].each_with_index do |result,index|
          not_registered_ids << registration_id[index] if is_not_registered?(result)
        end
      end
    end
    not_registered_ids
  end

  def has_canonical_id?(result)
    !result['registration_id'].nil?
  end

  def is_not_registered?(result)
    result['error'] == 'NotRegistered'
  end
end
