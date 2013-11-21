require 'spec_helper'

describe Comment do

   it "should have some content" do
    Comment.new(content: "hello", user_id: "1", post_id: "2").should be_valid
    Comment.new(content: "", user_id: "1",post_id: "2").should_not be_valid
  end

  it "should have some valid user" do
    user = User.create(email: 'dsfx@dfsfx.com',password: 'yoyoyoyo') if User.count == 0
    comment = Comment.new(content: "hello", user_id: User.last.id, post_id: '2')
    expect(comment.user).should be_valid

    user = User.create(email: 'dsfx@dfsfx.com',password: 'yoyoyoyo') if User.count == 0
    comment = Comment.new(content: "hello", user_id: nil, post_id: '2')
    expect(comment.user).should be_nil
  end


  it "should have a post to comment on" do
    post = Post.create(content: "hello", user_id: "1") if Post.count == 0
    comment = Comment.new(content: "hello", user_id: "1", post_id: Post.last.id)
    expect(comment.post).should be_valid

    post = Post.create(content: "hello", user_id: "1") if Post.count == 0
    comment = Comment.new(content: "hello", user_id: "1", post_id: nil)
    expect(comment.post).should be_nil
  end
end
