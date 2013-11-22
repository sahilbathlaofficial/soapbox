require 'spec_helper'

describe Comment do

  before(:all) do
    User.create(email: 'dsfx@dfsfx.com',password: 'yoyoyoyo') 
    Post.create(content: "hello", user_id: User.last.id) 
    User.create(email: 'dsfxs@dfsfx.com',password: 'yoyoyoyo') 
  end

   it "should have some content" do
    Comment.new(content: "hello", user_id: "1", post_id: "2").should be_valid
    Comment.new(content: "", user_id: "1",post_id: "2").should_not be_valid
  end

  it "should have some valid user" do
    
    comment = Comment.new(content: "hello", user_id: User.last.id, post_id: '2')
    expect(comment.user.valid?).to  eq(true)

    comment = Comment.new(content: "hello", user_id: nil, post_id: '2')
    expect(comment.user).to  eq(nil)
  end


  it "should have a post to comment on" do
   
    comment = Comment.new(content: "hello", user_id: "1", post_id: Post.last.id)
    expect(comment.post.valid?).to  eq(true)

    comment = Comment.new(content: "hello", user_id: "1", post_id: nil)
    expect(comment.post).to  eq(nil)
  end

  it "should have a valid owner" do
    comment = Comment.new(content: "hello", user_id: User.last.id, post_id: Post.last.id)
    expect(comment.owner?(comment.user)).to eq(true)
    expect(comment.owner?(User.first)).to eq(false) 
  end


  after(:all) do
    User.destroy_all
    Post.destroy_all
  end

end
