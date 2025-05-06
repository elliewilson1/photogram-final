class CreatePhotos < ActiveRecord::Migration[7.1]
  def change
    create_table :photos do |t|
      t.text :caption
      t.string :image
      t.integer :owner_id
      t.integer :comments_count
      t.integer :likes_count

      t.timestamps
    end
  end
end
