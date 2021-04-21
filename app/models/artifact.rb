class Artifact < ApplicationRecord
  include Rails.application.routes.url_helpers
  extend FriendlyId
  friendly_id :title, use: :slugged

  after_create :generate_qr_code
  after_destroy :destroy_qr_code

  def generate_qr_code
		Rails.logger.info "*** Attempting to generate qr code ***"
		qrcode = RQRCode::QRCode.new(TegrQR::DOMAIN + artifact_path(self))

		png = qrcode.as_png(
		  bit_depth: 1,
		  border_modules: 4,
		  color_mode: ChunkyPNG::COLOR_GRAYSCALE,
		  color: 'black',
		  file: nil,
		  fill: 'white',
		  module_px_size: 6,
		  resize_exactly_to: false,
		  resize_gte_to: false,
		  size: 120
		)

		save_png(png, self)
	end

	def destroy_qr_code
		delete_png(self)
	end
end
