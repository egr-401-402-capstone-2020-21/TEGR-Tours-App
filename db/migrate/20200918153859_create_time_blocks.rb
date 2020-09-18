class CreateTimeBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :time_blocks do |t|
      t.string :day_of_week
      t.string :start_time
      t.string :end_time

      t.timestamps
    end
  end
end
