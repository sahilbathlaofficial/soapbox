class CreateGroupMemberships < ActiveRecord::Migration
  def change
    create_table :group_memberships do |t|
      t.references :user, index: true
      t.references :group, index: true

      t.timestamps
    end
  end
end
