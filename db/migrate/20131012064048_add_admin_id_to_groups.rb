class AddAdminIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :admin_id, :integer
  end
end
