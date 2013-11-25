class AddTwitterAuthorizeTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_authorize_token, :text
  end
end
