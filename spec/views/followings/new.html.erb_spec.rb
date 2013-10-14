require 'spec_helper'

describe "followings/new" do
  before(:each) do
    assign(:following, stub_model(Following,
      :create => "MyString",
      :destroy => "MyString",
      :user_id => 1,
      :follower_id => 1
    ).as_new_record)
  end

  it "renders new following form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", followings_path, "post" do
      assert_select "input#following_create[name=?]", "following[create]"
      assert_select "input#following_destroy[name=?]", "following[destroy]"
      assert_select "input#following_user_id[name=?]", "following[user_id]"
      assert_select "input#following_follower_id[name=?]", "following[follower_id]"
    end
  end
end
