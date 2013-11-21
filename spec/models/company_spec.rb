require 'spec_helper'

describe Company do
   it "should have a name" do
    Company.new(name: "company").should be_valid
    Company.new(name: "").should_not be_valid
  end
end
