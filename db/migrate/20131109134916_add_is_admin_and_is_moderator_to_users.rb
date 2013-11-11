class AddIsAdminAndIsModeratorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_admin, :boolean
    add_column :users, :is_moderator, :boolean
  end
end
