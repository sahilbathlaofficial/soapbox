require 'spec_helper'

describe GroupMembership do

  let(:user) do
    User.create(email: 'sahil@vinsol.com', company_id: '1', password: '12345678')
  end

  let(:user_alpha) do
    User.create(email: 'sahila@vinsol.com', company_id: '1', password: '12345678')
  end

  let(:group) do
    Group.create(admin_id: user.id, company_id: '1', name: 'xyz')
  end

  let(:group_membership) do
    GroupMembership.create(group_id: group.id, user_id: user.id)
  end

   describe 'validations' do
    describe 'presence' do

      context 'user_id' do
        it { should validate_presence_of(:user_id) }
      end

      context 'group_id' do
        it { should validate_presence_of(:group_id) }
      end

    end
  end
  
  describe 'belongs to' do
   
    context 'user' do
      it { should belong_to(:user) }
    end

    context 'group' do
      it { should belong_to(:group) }
    end
 
  end

  describe 'destroy_group on group membership destroy' do

    context 'if group admin = user_id' do
      it do
        group_membership.destroy
        expect(group_membership.group.destroyed?).to eq(true)
      end
    end

    context 'if not group admin' do
      it do
        group_membership = GroupMembership.new(group_id: group.id, user_id: user_alpha.id)
        group_membership.destroy
        expect(group_membership.group.destroyed?).to eq(false)
      end
    end

  end

  describe 'check states of membership' do
  end

  # after(:all)
  #   Group.delete_all
  # end

end
