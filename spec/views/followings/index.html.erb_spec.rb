require 'spec_helper'

describe "followings/index" do
  before(:each) do
    assign(:followings, [
      stub_model(Following,
        :create => "Create",
        :destroy => "Destroy",
        :user_id => 1,
        :follower_id => 2
      ),
      stub_model(Following,
        :create => "Create",
        :destroy => "Destroy",
        :user_id => 1,
        :follower_id => 2
      )
    ])
  end

  it "renders a list of followings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Create".to_s, :count => 2
    assert_select "tr>td", :text => "Destroy".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
