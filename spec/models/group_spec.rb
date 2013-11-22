require 'spec_helper'

describe Group do
  it "should have a valid name" do
    Group.new(name: "group", admin_id: "1", company_id:"1").should be_valid
    Group.new(name: "", admin_id: "1", company_id:"1").should_not be_valid
  end

  it "should have atleast one user" do
    @group = Group.create(name: "group", admin_id: "1", company_id:"1")
    expect(@group.users.count).to eq(1)
  end
end
