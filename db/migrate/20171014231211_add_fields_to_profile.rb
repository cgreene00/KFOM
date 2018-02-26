class AddFieldsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :order_total, :string, default: '0'
    add_column :profiles, :business_name, :string
    add_column :profiles, :payable_to, :string
  end
end
