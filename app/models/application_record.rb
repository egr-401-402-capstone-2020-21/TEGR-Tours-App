class ApplicationRecord < ActiveRecord::Base
  	self.abstract_class = true
	module TegrQR
		DOMAIN = "http://tegrtours.com"
		QR_PATH = Rails.root.join('public', 'qr_codes')
	end

	def save_png(png, record)
		Rails.logger.info "*** Attempting to save file ***"
		IO.binwrite(png_path(record), png.to_s)
	end

	def delete_png(record)
		File.delete(png_path(record)) if File.exist?(png_path(record))
	end

	def png_path(record)
		"#{TegrQR::QR_PATH}/#{record.class.name}_#{record.slug}.png"
	end
end
