class Room < ApplicationRecord
	extend FriendlyId
	has_many :courses
	friendly_id :name, use: :slugged
end
