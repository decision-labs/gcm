require 'spec_helper'

describe GCM do
  it "should raise an error if the api key is not provided" do
    expect {GCM.new}.to raise_error
  end
end