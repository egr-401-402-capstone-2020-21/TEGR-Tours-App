class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
