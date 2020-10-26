class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :course_id
      t.string :instructor
      t.string :description
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
