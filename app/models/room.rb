class Room < ApplicationRecord
	has_many :courses
	has_many :time_blocks, through: :courses
	has_one :datum
end
