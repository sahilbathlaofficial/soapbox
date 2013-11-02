class CreateURLParsedContents < ActiveRecord::Migration
  def change
    create_table :url_parsed_contents do |t|
      t.references :post, index: true
      t.references :user, index: true
      t.string :title
      t.string :description
      t.text :image_url
      t.string :video_id
      t.text :url

      t.timestamps
    end
  end
end
