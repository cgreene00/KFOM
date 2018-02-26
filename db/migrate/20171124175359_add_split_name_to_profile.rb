class AddSplitNameToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :firstname, :string
    add_column :profiles, :lastname, :string
  end
end
