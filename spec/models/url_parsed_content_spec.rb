require 'spec_helper'

describe URLParsedContent do
  
  before(:each) do
    @url_content = URLParsedContent.new(url: "http://company.vinsol.com", post_id: "1")
  end

  it "should have a valid url if any " do
    URLParsedContent.new(url: "company@vinsol.com").should_not be_valid
    URLParsedContent.new(url: "").should_not be_valid
    @url_content.should be_valid
  end

  it "should have a valid post id" do
    @url_content.should be_valid
  end
end
