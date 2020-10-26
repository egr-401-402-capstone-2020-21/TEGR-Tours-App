json.extract! course, :id, :title, :course_id, :instructor, :description, :room_id, :created_at, :updated_at
json.url course_url(course, format: :json)
