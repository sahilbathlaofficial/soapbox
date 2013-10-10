class AddConnectionIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :connection_id, :integer
  end
end
