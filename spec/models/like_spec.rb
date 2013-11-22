require 'spec_helper'

  describe Like do
    before(:each) do
    @user = User.create(email: 'dsfx@dfsfx.com',password: 'yoyoyoyo') 
    @post = Post.create(content: 'hello', user_id: @user)
    @like = Like.create(user_id: @user.id, post_id: @post.id)
  end

  it "should have a post_id and user_id" do
    Like.new(user_id: @user.id, post_id: "5").should be_valid
    Like.new(user_id: @user.id, post_id: nil).should_not be_valid
    Like.new(user_id: nil, post_id: @post.id).should_not be_valid
  end

  it "should be unique in terms of post and user" do
    Like.new(user_id: @user.id, post_id: @post.id).should_not be_valid
  end
end
