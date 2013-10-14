require 'spec_helper'

describe "followings/edit" do
  before(:each) do
    @following = assign(:following, stub_model(Following,
      :create => "MyString",
      :destroy => "MyString",
      :user_id => 1,
      :follower_id => 1
    ))
  end

  it "renders the edit following form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", following_path(@following), "post" do
      assert_select "input#following_create[name=?]", "following[create]"
      assert_select "input#following_destroy[name=?]", "following[destroy]"
      assert_select "input#following_user_id[name=?]", "following[user_id]"
      assert_select "input#following_follower_id[name=?]", "following[follower_id]"
    end
  end
end
