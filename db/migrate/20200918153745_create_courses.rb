class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :code
      t.string :instructor
      t.string :desc

      t.timestamps
    end
  end
end
