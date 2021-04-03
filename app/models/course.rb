class Course < ApplicationRecord
  extend FriendlyId
  friendly_id :course_id, use: :slugged
  
  belongs_to :room
  has_many :time_blocks
end
