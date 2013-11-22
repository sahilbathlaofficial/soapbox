require 'spec_helper'

describe Company do

  before(:each) do
    @company = Company.new(name: "vinsol")
  end

  it "should have a name" do
    @company.should be_valid
    Company.new(name: "").should_not be_valid
  end

  it "should be unique" do
    Company.create(name: "vinsol")
    @company.should_not be_valid
    Company.new(name: "Vinsol").should_not be_valid
  end
  
end
