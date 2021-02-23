class Room < ApplicationRecord
	include Rails.application.routes.url_helpers
	extend FriendlyId
	has_many :courses
	validates :name, uniqueness: true
	friendly_id :name, use: :slugged

	after_create :generate_qr_code
	after_destroy :destroy_qr_code

	def generate_qr_code
		Rails.logger.info "*** Attempting to generate qr code ***"
		qrcode = RQRCode::QRCode.new(TegrQR::DOMAIN + room_path(self))

		# NOTE: showing with default options specified explicitly
		svg = qrcode.as_svg(
			offset: 0,
			color: '000',
			shape_rendering: 'crispEdges',
			module_size: 6,
			standalone: true)

		save_svg(svg, self)
	end


	def destroy_qr_code
		delete_svg(self)
	end
end
