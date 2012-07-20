require 'spec_helper'

describe GCM do
  let(:api_key) { 'my-api-key' }
  subject{GCM.new(api_key)}

  it "should raise an error if the api key is not provided" do
    expect{GCM.new}.to raise_error
  end

  it "should raise error if time_to_live is given" do
    # ref: http://developer.android.com/guide/google/gcm/gcm.html#send-msg
  end

  describe "sending notification" do
    let(:registration_ids) { [ "42" ]}
    let(:valid_request_body) do
      { registration_ids: registration_ids }
    end
    let(:valid_request_headers) do
      {
        "Content-Type" => 'application/json',
        "Authorization" => "key=#{api_key}"
      }
    end

    before(:each) do
      stub_request(:post, GCM::PUSH_URL).with(
        body: valid_request_body.to_json,
        headers: valid_request_headers
      ).to_return(
        # ref: http://developer.android.com/guide/google/gcm/gcm.html#success
        body: {},
        headers: {},
        status: 200
      )
    end

    it "should send notification using POST to GCM server" do 
      subject{send_notification(registration_ids).should eq({response: 'success', body: {}, headers: {}, status_code: 200})}
    end

    context "send notification with data" do
      let!(:stub_with_data){
        stub_request(:post, GCM::PUSH_URL).
          with(body: "{\"registration_ids\":[\"42\"],\"data\":{\"score\":\"5x1\",\"time\":\"15:10\"}}",
               headers: valid_request_headers ).
          to_return(status: 200, body: "", headers: {})
      }
      before do
      end
      it "should send the data in a post request to gcm" do
        subject.send_notification(registration_ids, { data: { score: "5x1", time: "15:10"} })
        stub_with_data.should have_been_requested
      end
    end
    context "On failure" do
      
      it "should not send notification due to 400" do
          stub_request(:post, GCM::PUSH_URL).with(
            body: valid_request_body.to_json,
            headers: valid_request_headers
          ).to_return(
            # ref: http://developer.android.com/guide/google/gcm/gcm.html#success
            body: {},
            headers: {},
            status: 400
          )
          subject.send_notification(registration_ids).should eq({:response=>"Only applies for JSON requests. Indicates that the request could not be parsed as JSON, or it contained invalid fields.", :status_code=>400})
      end
 
      it "should not send notification due to 401" do
          stub_request(:post, GCM::PUSH_URL).with(
            body: valid_request_body.to_json,
            headers: valid_request_headers
          ).to_return(
            # ref: http://developer.android.com/guide/google/gcm/gcm.html#success
            body: {},
            headers: {},
            status: 401
          )
          subject.send_notification(registration_ids).should eq({:response=>"There was an error authenticating the sender account.", :status_code=>401})
      end
      
      it "should not send notification due to 500" do
          stub_request(:post, GCM::PUSH_URL).with(
            body: valid_request_body.to_json,
            headers: valid_request_headers
          ).to_return(
            # ref: http://developer.android.com/guide/google/gcm/gcm.html#success
            body: {},
            headers: {},
            status: 500
          )
          subject.send_notification(registration_ids).should eq({response: 'There was an internal error in the GCM server while trying to process the request.', status_code: 500})
      end
  
      it "should not send notification due to 503" do
          stub_request(:post, GCM::PUSH_URL).with(
            body: valid_request_body.to_json,
            headers: valid_request_headers
          ).to_return(
            # ref: http://developer.android.com/guide/google/gcm/gcm.html#success
            body: {},
            headers: {},
            status: 503
          )
          #gcm = GCM.new(api_key)
          subject.send_notification(registration_ids).should eq({response: 'Server is temporarily unavailable.', status_code: 503})
      end
    end
  end
end
