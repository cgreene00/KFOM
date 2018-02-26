class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user
      t.string :title
      t.text :description
      t.string :price
      t.string :unit
      t.boolean :active, default: true

      t.timestamps null: false
    end
    add_index :posts, :title
  end
end
