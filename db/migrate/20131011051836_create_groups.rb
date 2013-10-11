class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :type
      t.string :description
      t.references :connection, index: true

      t.timestamps
    end
  end
end
