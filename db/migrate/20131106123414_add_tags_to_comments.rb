class AddTagsToComments < ActiveRecord::Migration
  def change
    add_column :comments, :tags, :string
  end
end
