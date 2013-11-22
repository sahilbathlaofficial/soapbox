require 'spec_helper'

describe Following do

  before(:all) do
    Company.create(name:'vinsol')
    @user_alpha = User.create(email: 'dsfx@dfsfx.com',password: 'yoyoyoyo', company_id: Company.last.id)
    @user_beta = User.create(email: 'dsfxs@dfsfx.com',password: 'yoyoyoyo', company_id: Company.last.id)
  end

  it "should have a user_id and followee_id" do
    Following.new(user_id: "1", followee_id: "2").should be_valid
    Following.new(user_id: "1", followee_id: nil).should_not be_valid
    Following.new(user_id: nil, followee_id: "1").should_not be_valid
  end

  it "should have a unique following" do
    Following.skip_callback(:create, :after, :notify_followee)
    Following.create(user_id: @user_alpha.id, followee_id: @user_beta.id)
    Following.new(user_id: @user_alpha.id, followee_id: @user_beta.id).should_not be_valid
  end

  after(:all) do
    Company.destroy_all
    User.destroy_all
  end
end