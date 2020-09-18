class CreateData < ActiveRecord::Migration[5.2]
  def change
    create_table :data do |t|
      t.belongs_to :room
      t.string :title
      t.string :desc

      t.timestamps
    end
  end
end
