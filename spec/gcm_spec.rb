require 'spec_helper'

describe GCM do
  it "should raise an error if the api key is not provided" do
    expect {GCM.new}.to raise_error
  end

  it "should raise error if time_to_live is given" do
    # ref: http://developer.android.com/guide/google/gcm/gcm.html#send-msg
  end

  describe "sending notification" do
    let(:api_key) { 'AIzaSyB-1uEai2WiUapxCs2Q0GZYzPu7Udno5aA' }
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
      gcm = GCM.new(api_key)
      gcm.send_notification(registration_ids).should eq({body: {}, headers: {}, status: 200})
    end
  end
end