require 'spec_helper'

describe Company do

  let(:admin) do
    User.create(email: 'sahil@vinsol.com', is_admin: true)
  end

  let(:user) do
    User.create(email: 'sahila@vinsol.com')
  end

  let(:company) do
    Company.create(name: 'vinsol')
  end

  describe 'validation' do
    
    describe 'presence' do
      context 'name' do
        it { should validate_presence_of(:name) }
      end
    end

    describe 'uniqueness - case_insensitive' do
      describe 'name' do
        it { should validate_uniqueness_of(:name).case_insensitive }
      end
    end

  end

  describe 'has_many' do

    context 'users' do
      it { should have_many(:users) }
    end

    context 'groups' do
      it { should have_many(:groups) }
    end

  end

  describe 'manage_companies' do

    context 'not an admin ' do
      it { expect(Company.manage_companies(user, nil)).to eq(nil) }
    end

    context 'admin but no params[:to_ban] passed' do
      it { expect(Company.manage_companies(admin, nil)).to eq(true) }
    end

    context 'admin and param[:to_ban] junk' do
      it { expect(Company.manage_companies(admin, "sdsdsd")).to eq(false) }
    end

    context 'admin and param[:to_ban] contains records not in DB' do
      it { expect(Company.manage_companies(admin, "-1 -2")).to eq(false) }
    end

    context 'admin and param[:to_ban] correct' do
      it { expect(Company.manage_companies(admin, {to_ban: company.id.to_s} )).to eq(true) }
    end

  end

  
end
