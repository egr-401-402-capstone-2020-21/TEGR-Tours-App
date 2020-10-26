class Course < ApplicationRecord
  belongs_to :room
  has_many :time_blocks
end
