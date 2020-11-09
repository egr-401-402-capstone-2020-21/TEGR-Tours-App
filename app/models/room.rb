class Room < ApplicationRecord
	extend FriendlyId
	has_many :courses
	validates :name, uniqueness: true
	friendly_id :name, use: :slugged
end
