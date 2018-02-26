class AddWeekToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :week, index: true, foreign_key: true
  end
end
