require 'spec_helper'

describe Following do

  describe 'validations' do
    describe 'presence' do

      context 'user_id' do
        it { should validate_presence_of(:user_id) }
      end

      context 'followee_id' do
        it { should validate_presence_of(:followee_id) }
      end

    end

    describe 'uniqueness' do
      context 'user_id scope followee_id' do
        it { should validate_uniqueness_of(:user_id).scoped_to(:followee_id)  }
      end
    end
  end

  describe 'belongs to' do
    context 'user' do
      it { should belong_to(:user) }
    end

    context 'followee' do
      it { should belong_to(:followee).class_name('User') }
    end
  end

  describe 'include PublicActivity' do
    context 'respond to enable?' do
      it { expect(Following.new.public_activity_enabled?).to eq(true) }
    end 
  end

end