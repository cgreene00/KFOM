class AddFieldsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :submitted, :boolean, default: false
    add_column :orders, :archived, :boolean, default: false
  end
end
