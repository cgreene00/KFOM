class AddFieldToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :registered, :boolean, default: false
    add_column :profiles, :terms_of_service, :boolean, default: false
    add_column :profiles, :minimum_order, :string, default: "0"
  end
end
