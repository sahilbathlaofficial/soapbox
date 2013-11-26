class AddConsumerKeyAndConsumerSecretToUsers < ActiveRecord::Migration
  def change
    add_column :users, :consumer_key, :text
    add_column :users, :consumer_secret, :text
  end
end
