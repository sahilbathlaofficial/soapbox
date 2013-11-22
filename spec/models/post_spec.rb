require 'spec_helper'

describe Post do

  before(:all) do
    @company = Company.create(name: 'vinsol')
    @user = User.create(email: 'dsfx@dfsfx.com', password: 'yoyoyoyo', company_id: @company.id) 
    @group = Group.create(name: 'ror',admin_id: @user.id, company_id: @company.id)
  end

  before(:each) do
     @post = Post.new(content: "hello", user_id: @user.id, tags: @user.id.to_s)
     @post.stub(:email_tagged_users) { true }
  end
  
  it "should have some content" do
    Post.new(content: "hello", user_id: @user.id).should be_valid
    Post.new(content: "", user_id: @user.id).should_not be_valid
  end

  it "should have some valid user" do
    
    post = Post.new(content: "hello", user_id: @user.id)
    post.user.should be_valid

    post = Post.new(content: "hello", user_id: nil)
    expect(post.user).to eq(nil)
  end

  it "should have some valid group or no group at all" do
    
    post = Post.new(content: "hello", user_id: @user)
    expect(post.group).to eq(nil)

    post = Post.new(content: "hello", user_id: @user.id, group_id: @group.id)
    expect(post.group).to eq(@group)

    post = Post.new(content: "hello", user_id: @user.id, group_id: "-1")
    expect(post.group).to eq(nil)  

  end

  it "should notify tagged users" do
    notifications_count = PublicActivity::Activity.where(owner_id: @user.id).count 
    @post.save
    expect(PublicActivity::Activity.where(owner_id: @user.id).count).to eq(notifications_count + 1)
  end

  it "should destroy associated comments, likes and url_parsed content with on deletion" do
    @post.save
    @post.destroy
    expect([Comment.where(post_id: @post.id), Like.where(post_id: @post.id), URLParsedContent.where(post_id: @post.id)]).to eq([[], [], []])
  end

  after(:all) do
    @company.destroy
    @user.destroy
    @group.destroy
    @post.destroy
  end

end
