class Course < ApplicationRecord
  extend FriendlyId
  belongs_to :room
  has_many :time_blocks
  friendly_id :title, use: :slugged
end
