require 'spec_helper'

describe User do
  it "should have a email" do
    User.new(email: "company@vinsol.com",password: "yoyoyoyo").should be_valid
    User.new(email: "",password: "yoyoyoyo").should_not be_valid
    User.new(email: "sdsdsdsdsdsd",password: "yoyoyoyo").should_not be_valid
  end

  it "should have a password of atleast 8 letters" do
    User.new(email: "company@vinsol.com",password: "yoyoyoyo").should be_valid
    User.new(email: "",password: nil).should_not be_valid
    User.new(email: nil,password: "sdsds").should_not be_valid
    User.new(email: nil,password: 232323).should_not be_valid
  end

  it "should provide dummy names on creation" do
    u = User.new(email: "company@vinsol.com",password: "yoyoyoyo")
    initially_name = u.name
    u.save
    expect([initially_name.blank?, u.name.blank?]).to eq([true, false])
  end

  it "name should exactly match firstname + lastname" do
    u = User.new(email: "company@vinsol.com",password: "yoyoyoyo")
    u.save
    expect(u.name).to eq(u.firstname.capitalize + " " + u.lastname.capitalize)
  end

  it "should have valid parameterization" do
    u = User.new(email: "company@vinsol.com",password: "yoyoyoyo")
    u.save
    expect(u.to_param).to eq("#{u.id}-#{u.firstname.parameterize}")
  end

  it "should be privileged only if admin or moderator" do
    u = User.new(email: "company@vinsol.com",password: "yoyoyoyo")
    expect(u.privileged?(self)).to eq(false)

    u = User.new(email: "company@vinsol.com",password: "yoyoyoyo",is_admin: true)
    expect(u.privileged?(self)).to eq(true)

    u = User.new(email: "company@vinsol.com",password: "yoyoyoyo",is_moderator: true)
    expect(u.privileged?(self)).to eq(true)
  end

end
