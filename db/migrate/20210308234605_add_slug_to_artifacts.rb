class AddSlugToArtifacts < ActiveRecord::Migration[5.2]
  def change
    add_column :artifacts, :slug, :string
    add_index :artifacts, :slug, unique: true
  end
end
