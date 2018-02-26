class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.date :start
      t.date :end

      t.timestamps null: false
    end
  end
end
