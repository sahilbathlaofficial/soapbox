require 'spec_helper'

describe Following do
   it "should have a user_id and followee_id" do
    Following.new(user_id: "1", followee_id: "2").should be_valid
    Following.new(user_id: "1", followee_id: nil).should_not be_valid
    Following.new(user_id: nil, followee_id: "1").should_not be_valid
  end
end
