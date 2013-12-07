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
    GroupMembership.new(group_id: group.id, user_id: user_alpha.id)
  end

  let(:group_membership_admin) do
    group.group_memberships.find_by(user_id: user.id)
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
        group_membership_admin.destroy
        expect(group_membership_admin.group.destroyed?).to eq(true)
      end
    end

    context 'if not group admin' do
      it do
        group_membership.destroy
        expect(group_membership.group.destroyed?).to eq(false)
      end
    end

  end

  describe 'states of membership' do
    
    context 'new membership is pending' do
      it { expect(group_membership.pending?).to eq(true) }
    end

    context 'new membership is not approved' do
      it { expect(group_membership.approved?).to eq(false) }
    end
    
    context 'approve membership' do
      it do
        group_membership.approve
        expect(group_membership.approved?).to eq(true) 
      end
    end

    context 'approved membership is not pending' do
      it do
        group_membership.approve
        expect(group_membership.pending?).to eq(false) 
      end
    end

    context 'membership state other than 0 or 1 should not be valid' do
      it do
        should ensure_inclusion_of(:state).in_array([0,1]) 
      end
    end

    context 'state\'s value when pending is 0' do
      it { expect(group_membership.state).to eq(0) }
    end
    
    context 'state\'s value when approved is 1' do
      it do
        group_membership.approve
        expect(group_membership.state).to eq(1) 
      end
    end

    context 'event approve exist to transit from pending to approved' do
      it do
        initial_group_mebership_status = group_membership.state_name
        group_membership.approve
        expect([initial_group_mebership_status, group_membership.state_name]).to eq([:pending, :approved]) 
      end
    end

  end

  # after(:all)
  #   Group.delete_all
  # end

end
