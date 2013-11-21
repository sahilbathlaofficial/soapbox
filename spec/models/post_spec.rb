require 'spec_helper'

describe Post do
  
  it "should have some content" do
    Post.new(content: "hello", user_id: "1").should be_valid
    Post.new(content: "", user_id: "1").should_not be_valid
  end

  it "should have some valid user" do
    user = User.create(email: 'dsfx@dfsfx.com',password: 'yoyoyoyo') if User.count == 0
    post = Post.new(content: "hello", user_id: User.last.id)
    expect(post.user).should be_valid

    user = User.create(email: 'dsfx@dfsfx.com',password: 'yoyoyoyo') if User.count == 0
    post = Post.new(content: "hello", user_id: nil)
    expect(post.user).should be_nil
  end

end
