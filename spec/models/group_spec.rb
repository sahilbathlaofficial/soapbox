require 'spec_helper'

describe Group do
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
end
