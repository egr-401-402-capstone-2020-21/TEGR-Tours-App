class AddSlugToDisplays < ActiveRecord::Migration[5.2]
  def change
    add_column :displays, :slug, :string
    add_index :displays, :slug, unique: true
  end
end
