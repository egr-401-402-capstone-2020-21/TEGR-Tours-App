class ApplicationRecord < ActiveRecord::Base
  	self.abstract_class = true
	module TegrQR
		DOMAIN = "http://10.147.19.131:3001"
		QR_PATH = "#{Rails.root}/app/assets/images/qr_codes"
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
