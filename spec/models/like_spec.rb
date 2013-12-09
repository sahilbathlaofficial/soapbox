require 'spec_helper'

describe Like do

  describe 'validation' do
    describe 'presence of ' do
    
      context 'user_id' do
        it { should validate_presence_of(:user_id) }
      end
    
      context 'post_id' do
        it { should  validate_presence_of(:post_id) }
      end
    
    end

    describe 'uniqueness of' do
      context 'user_id' do
        it { should validate_uniqueness_of(:user_id).scoped_to(:post_id) } 
      end
    end
  end

  describe 'association' do
    describe 'belongs to ' do
    
      context 'user' do
        it { should belong_to(:user) }
      end
    
      context 'post' do
        it { should  belong_to(:post) }
      end
    
    end
  end

end
