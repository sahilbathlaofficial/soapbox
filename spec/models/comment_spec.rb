require 'spec_helper'

describe Comment do

  before(:all) do
    Company.create(name: 'vinsol')
    User.create(email: 'dsfx@dfsfx.com',password: 'yoyoyoyo', company_id: Company.last.id) 
    Thread.current[:user] = User.first
    Post.create(content: "hello", user_id: User.last.id) 
    User.create(email: 'dsfxs@dfsfx.com', password: 'yoyoyoyo', company_id: Company.last.id) 
  end 

  describe "validation" do

    context "content" do
      it { should validate_presence_of(:content) }
    end

    context "user_id" do
      it { should validate_presence_of(:user_id) }
    end

    context "post_id" do
      it { should validate_presence_of(:post_id) }
    end

  end

  describe 'belongs to' do
    context 'user' do
      it { should belong_to(:user) }
    end
    context 'post' do
      it { should belong_to(:post) } 
    end
  end

  describe 'owner?' do
    context 'user is owner' do
      comment = Comment.new(content: 'hi', user_id: User.first.id, post_id: '2')
      it { expect(comment.owner?(Thread.current[:user])).to eq(true)  }
    end

    context 'user is not owner' do
      comment = Comment.new(content: 'hi', user_id: User.first.id, post_id: '2')
      it { expect(comment.owner?(User.last)).to eq(false)  }
    end
  end

  describe 'current user' do 
    context 'current user is same as Thread.current[:user]' do
      comment = Comment.new(content: 'hi', user_id: User.first.id, post_id: '2')
      it { expect(comment.current_user).to eq(Thread.current[:user])  }
    end
  end



  after(:all) do
    User.destroy_all
    Post.destroy_all
    Company.destroy_all
  end

end
