class Room < ApplicationRecord
	include Rails.application.routes.url_helpers
	extend FriendlyId
	has_many :courses
	validates :name, uniqueness: true
	friendly_id :name, use: :slugged


	after_create :generate_qr_code
	def generate_qr_code
		qrcode = RQRCode::QRCode.new(TegrQR::DOMAIN + room_path(self))
		Rails.logger.info "*** Generate QR CODE ***"

		# NOTE: showing with default options specified explicitly
		svg = qrcode.as_svg(
			offset: 0,
			color: '000',
			shape_rendering: 'crispEdges',
			module_size: 6,
			standalone: true)

		save_svg(svg, "room", self.id)
	end
end
