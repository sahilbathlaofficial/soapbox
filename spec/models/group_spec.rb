require 'spec_helper'

describe Group do

  let(:site_admin) do
    User.create(email: 'sahilb@vinsol.com', company_id: '1', password: '12345678', is_admin: true)
  end

  let(:group_admin) do
    User.create(email: 'sahil@vinsol.com', company_id: '1', password: '12345678')
  end

  let(:user) do
    User.create(email: 'sahila@vinsol.com', company_id: '1', password: '12345678')
  end

  let(:group) do
    Group.create(admin_id: group_admin.id, company_id: '1', name: 'xyz')
  end

  describe 'associations' do
    describe 'has_many' do

      context 'group_membership' do
        it { should have_many(:group_memberships).dependent(:destroy) }
      end
    
      context 'users' do
        it { should have_many(:users).through(:group_memberships) }
      end

      context 'posts' do
        it { should have_many(:posts).dependent(:destroy).order('created_at DESC') }
      end
    
    end

    describe 'belongs_to' do

      context 'company' do
        it { should belong_to(:company) }
      end

      context 'admin' do
        it { should belong_to(:admin).with_foreign_key('admin_id').class_name('User') }
      end

    end
  end

  describe 'validation' do

    describe 'presence' do
      
      context 'name' do
        it { should validate_presence_of(:name) }
      end
      
      context 'company_id' do
        it { should validate_presence_of(:company_id) }
      end
      
      context 'admin_id' do
        it { should validate_presence_of(:admin_id) }
      end
   
    end

    describe 'uniqueness' do
      context 'name' do
        it { should validate_uniqueness_of(:name).scoped_to(:company_id) }
      end
    end

    describe 'format' do
      context 'name' do
        it { should allow_value('ruby', 'rails' ,'123sdsdsdds').for(:name) }
        it { should_not allow_value('$sd', 'rails#234$', '').for(:name) } 
      end
    end

  end

  describe 'admin?' do
    context 'user is admin' do
      it { expect(group.admin?(group_admin)).to eq(true) }
    end

    context 'user is not an admin' do
      it do 
        expect(group.admin?(user)).to eq(false) 
      end
    end
  end

  describe 'manage_groups' do

    context 'not an admin ' do
      it { expect(Group.manage_groups(user, nil)).to eq(nil) }
    end

    context 'admin but no params[:to_ban] passed' do
      it { expect(Group.manage_groups(site_admin, nil)).to eq(true) }
    end

    context 'admin and param[:to_ban] junk' do
      it { expect(Group.manage_groups(site_admin, "sdsdsd")).to eq(false) }
    end

    context 'admin and param[:to_ban] contains records not in DB' do
      it { expect(Group.manage_groups(site_admin, "-1 -2")).to eq(false) }
    end

    context 'admin and param[:to_ban] correct' do
      it do
        Thread.current[:user] = site_admin
        expect(Group.manage_groups(site_admin, { to_ban: group.id.to_s } )).to eq(true) 
      end
    end

  end

end
