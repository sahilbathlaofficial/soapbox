require 'spec_helper'

describe Group do
  before(:all) do
    Company.create(name:'vinsol')
    @user_alpha = User.create(email: 'dsfx@dfsfx.com',password: 'yoyoyoyo', company_id: Company.last.id)
    @group = Group.create(name: "group", admin_id: @user_alpha.id, company_id: Company.last.id)
  end

  it "should have a valid name" do
    Group.new(name: "group", admin_id: "1", company_id:"1").should be_valid
    Group.new(name: "", admin_id: "1", company_id:"1").should_not be_valid
  end

  it "should have atleast one user" do
    expect(@group.users.count).to eq(1)
  end

  it "Should be unique in company's scope" do
    group =  Group.new(name: "group", admin_id: @user_alpha.id, company_id: Company.last.id)
    expect(group.valid?).to eq(false)
  end

  it "should destroy all the posts in it when it is destroyed" do
    post = Post.create(content: "hello", user_id: @user_alpha.id, group_id: @group.id)
    @group.destroy
    expect(Post.where(group_id:  @group.id).count).to eq(0)
  end

  after(:all) do
     Company.destroy_all
     User.destroy_all
     Group.destroy_all
  end
end
