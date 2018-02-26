class AddWeekToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :week, index: true, foreign_key: true
  end
end
