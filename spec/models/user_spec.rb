require 'spec_helper'

describe User do

  let(:company) do
    Company.create(name: 'xyz')
  end

  let(:user) do
    User.create(email: 'sahila@vinsol.com', company_id: company.id, password: '12345678')
  end

  let(:admin) do
    User.create(email: 'sahil@vinsol.com', company_id: company.id, password: '12345678', is_admin: true)
  end

  let(:post) do
    Post.create(content: 'hi', user_id: user.id)
  end

  let(:group) do
    Group.create(admin_id: user.id, company_id: company.id, name: 'xyz')
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
      it do
        user.is_admin = true
        expect(user.privileged?).to eq(true) 
      end
    end

    context 'when site moderator' do
      it do
        user.is_moderator = true
        expect(user.privileged?).to eq(true) 
      end
    end

    context 'when owner of an entity' do
      it do
        expect(user.privileged?(post)).to eq(true) 
      end
    end

    context 'when not privileged' do
      it do
        expect(user.privileged?).to eq(false) 
      end
    end
  end

  describe 'set_api_token' do
   
    context 'when user requests api token' do
      it do
        Thread.current[:user] = user
        expect(user.set_api_token.present?).to eq(true) 
      end
    end

    context 'when user requests api token' do
      it do
        Thread.current[:user] = nil
        expect(user.set_api_token.blank?).to eq(true) 
      end
    end

  end

  describe 'provide dummy names' do
    context 'user' do
      it { expect(user.name.present?).to eq(true) }
    end
  end

  describe 'scope' do
    describe 'extract users' do
      
      context 'when group_id and company_id is nil' do
        it { expect(User.extract_users(nil, nil) - User.all).to eq([]) }
      end

      context 'when group_id nil and company_id is given' do
        it { expect(User.extract_users(group.id, nil) - Group.find_by(id: group.id).users).to eq([]) }
      end

      context 'when group_id  and company_id are given' do
        it { expect(User.extract_users(group.id, company.id) - Company.find_by(id: company.id).groups.find_by(id: group.id).users).to eq([]) }
      end
    end

    describe 'match users' do

      context 'no query parameter' do
        it { expect(User.match_users(nil, nil).present?).to eq(false) }
      end

      context 'no query parameter' do
        it { expect(User.match_users(nil, company.id).present?).to eq(false) }
      end

      context 'when query parameter not matching user name' do
        it { expect(User.match_users('$%6', company.id).present?).to eq(false) }
      end

      context 'when query parameter not matching user name' do
        it { expect(User.match_users('%' + user.firstname.to_s + '%', company.id).present?).to eq(true) }
      end

    end

    describe 'extract tags' do

      context 'no query parameter' do
        it { expect(User.extract_tags(nil, nil).present?).to eq(false) }
      end

      context 'no query parameter' do
        it { expect(User.extract_tags(nil, [user.id.to_s]).present?).to eq(false) }
      end

      context 'when query parameter not matching user name' do
        it { expect(User.extract_tags('$%6', [user.id.to_s]).present?).to eq(false) }
      end

      context 'when query parameter not matching user name' do
        it { expect(User.extract_tags('%' + user.firstname.to_s + '%', [user.id.to_s]).present?).to eq(true) }
      end

    end
  end

  describe 'manage_users' do

    context 'when not an admin ' do
      it { expect(User.manage_users(user, nil)).to eq(nil) }
    end

    context 'by admin but no params[:to_ban] passed' do
      it { expect(User.manage_users(admin, nil)).to eq(false) }
    end

    context 'by admin and param[:to_ban] junk' do
      it { expect(User.manage_users(admin, "sdsdsd")).to eq(false) }
    end

    context 'by admin and param[:to_ban] contains records not in DB' do
      it { expect(User.manage_users(admin, "-1 -2")).to eq(false) }
    end

    context 'by admin and param[:to_ban] correct' do
      it do
        Thread.current[:user] = admin
        expect(User.manage_users(admin, { to_ban: user.id.to_s } )).to eq(true) 
      end
    end

  end

  describe 'avatar' do
    it { should have_attached_file(:avatar) }
    it { should validate_attachment_content_type(:avatar).allowing('image/png', 'image/gif') }
  end

end