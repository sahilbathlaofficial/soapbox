require 'spec_helper'

describe Like do
  it "should have a post_id and user_id" do
    Like.new(user_id: "1", post_id: "1").should be_valid
    Like.new(user_id: "1", post_id: nil).should_not be_valid
    Like.new(user_id: nil, post_id: "1").should_not be_valid
  end
end
