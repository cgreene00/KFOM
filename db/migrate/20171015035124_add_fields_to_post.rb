class AddFieldsToPost < ActiveRecord::Migration
  def change
    add_column :posts, :max_avaliable, :string, default: '0'
    add_column :posts, :special_instructions, :string
    add_column :posts, :archived, :boolean, default: false
  end
end
