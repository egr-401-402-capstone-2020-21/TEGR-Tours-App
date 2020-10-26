class CreateTimeBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :time_blocks do |t|
      t.string :week_day
      t.string :start_time
      t.string :end_time
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
