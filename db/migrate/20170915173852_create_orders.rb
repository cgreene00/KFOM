class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :post, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :current
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
