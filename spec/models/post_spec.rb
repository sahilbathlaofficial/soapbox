require 'spec_helper'

describe Post do

  let(:user) do
    User.create(email: 'sahila@vinsol.com', company_id: '1', password: '12345678')
  end

  let(:post) do
    Post.create(content: '#hash', user_id: user.id)
  end

  describe 'association' do
    describe 'belongs to' do
   
      context 'group' do
       it { should belong_to(:group) }
      end

      context 'user' do
       it { should belong_to(:user) }
      end

   end

    describe 'has many' do
   
      context 'likes' do
        it { should have_many(:likes).dependent(:destroy) }
      end

      context 'comments' do
        it { should have_many(:comments).dependent(:destroy) }
      end
     
    end

    describe 'has one url parsed content' do
   
      context 'url parsed content' do
        it { should have_one(:url_parsed_content).dependent(:destroy) }
      end
    end

  end

  describe 'validation' do
    describe 'presence of' do
      
      context 'post' do
       it { should validate_presence_of(:content) }
      end
      
      context 'user_id' do
       it { should validate_presence_of(:user_id) }
      end
    
    end
  end

  describe 'scope' do
   
    describe 'extract posts' do
    
      context 'no user no group' do
        it { expect(Post.extract_posts(nil,nil) - Post.all).to eq([]) }
      end
      
      context 'no user but groups present' do
        it { expect(Post.extract_posts(nil, [Group.last]).is_a?(ActiveRecord::Relation)).to eq(true) }
      end

      context 'users present but no group' do
        it { expect(Post.extract_posts([User.last], nil).is_a?(ActiveRecord::Relation)).to eq(true) }
      end

      context 'Users and groups present' do
        it { expect(Post.extract_posts([User.last], [Group.last]).is_a?(ActiveRecord::Relation)).to eq(true) }
      end

    end

    describe 'find_by_hash_tag' do
      
      context 'no user no content' do
        it { expect(Post.find_by_hash_tag('', nil).empty?).to eq(true) }
      end

      context 'no user with content' do
        it { expect(Post.find_by_hash_tag('hash', nil).empty?).to eq(true) }
      end

      context 'no content with users' do
        it do
          Thread.current[:user] = user
          expect(Post.find_by_hash_tag('', [user]).empty?).to eq(true) 
        end
      end

      context 'no content with users' do
        it do
          Thread.current[:user] = user
          expect(Post.find_by_hash_tag(post.content, [user]).empty?).to eq(false) 
        end 
      end

    end

  end

  describe 'destroy' do
    
    context 'if privileged' do
      it do
        Thread.current[:user] = user
        post.destroy
        expect(post.destroyed?).to eq(true)
      end
    end

    context 'if not privileged' do
      it do
        post.destroy
        expect(post.destroyed?).to eq(false)
      end
    end

  end

end