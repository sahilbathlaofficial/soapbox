require 'spec_helper'

describe URLParsedContent do
  it "should have a url" do
    URLParsedContent.new(url: "company@vinsol.com").should be_valid
    URLParsedContent.new(url: "").should_not be_valid
  end
end
