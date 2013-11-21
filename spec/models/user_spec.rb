require 'spec_helper'

describe User do
  it "should have a email and password" do
    User.new(email: "company@vinsol.com",password: "yoyoyoyo").should be_valid
    User.new(email: "company@vinsol.com",password: nil).should_not be_valid
    User.new(email: "",password: "yoyoyoyo").should be_valid
  end
end
