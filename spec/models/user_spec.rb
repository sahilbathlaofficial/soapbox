require 'spec_helper'

describe User do

  let(:user) do
    User.create(email: 'sahila@vinsol.com', company_id: '1', password: '12345678')
  end
  
  describe 'validation on' do
    describe 'presence of' do
      
      context 'email' do
        it { should validate_presence_of(:email) }
      end

      context 'password' do
        it { should validate_presence_of(:password) }
      end

    end

    describe 'uniqueness of' do
      context 'email' do
        it { should validate_uniqueness_of(:email) }
      end
    end

  end

  describe 'association' do
    
    describe 'belongs to' do
      context 'company' do
        it { should belong_to(:company) }
      end
    end
  
    describe 'has_many' do
      
      context 'following' do
        it { should have_many(:followings) }
      end
      
      context 'followees' do
        it { should have_many(:followees).through(:followings) }
      end
    
      context 'inverse following' do
        it { should have_many(:inverse_followings).with_foreign_key(:followee_id).class_name(:Following) }
      end
    
      context 'followers' do
        # source option not working in shoulda matcher
        it { should have_many(:followers).through(:inverse_followings).source(:user) }
      end
    
      context 'group_memberships' do
        it { should have_many(:group_memberships) }
      end

      context 'groups' do
        it { should have_many(:groups).through(:group_memberships) }
      end

      context 'group owned' do
        it { should have_many(:groups_owned).with_foreign_key(:admin_id).class_name(:Group).dependent(:destroy) }
      end

      context 'posts' do
        it { should have_many(:posts).order('created_at DESC') }
      end

      context 'likes' do
        it { should have_many(:likes) }
      end

      context 'comments' do
        it { should have_many(:comments) }
      end

    end
  end

  describe 'name' do
    
    context 'when firstname and lastname nil' do
      it do
        user.firstname = nil
        user.lastname = nil
        expect(user.name).to eq(' ') 
      end
    end

    context 'when firstname nil' do
      it do
        user.firstname = nil
        expect(user.name).to eq((' ' + user.lastname).titleize) 
      end
    end

    context 'when firstname and lastname nil' do
      it do
        user.lastname  = nil 
        expect(user.name).to eq((user.firstname + ' ').titleize) 
      end 
    end

    context 'when firstname and lastname present' do
      it do
        expect(user.name).to eq((user.firstname + ' ' + user.lastname).titleize) 
      end 
    end

  end


  describe 'to_param' do
    it { expect(user.to_param).to eq((user.id.to_s + '-' + user.firstname).parameterize) }
  end

  describe 'privileged?' do
    context 'when site admin' do
    end

    context 'when site moderator' do
    end

    context 'when owner' do
    end

    context 'when not privileged' do
    end
  end

end