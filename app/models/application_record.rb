class ApplicationRecord < ActiveRecord::Base
  	self.abstract_class = true
	module TegrQR
		DOMAIN = "http://10.147.19.131:3001"
		QR_PATH = "#{Rails.root}/app/assets/images/qr_codes"
	end

	def save_svg(svg, record)
		Rails.logger.info "*** Attempting to save file ***"
		aFile = File.new(svg_path(record), "w")
		if aFile
		   aFile.syswrite(svg)
		   Rails.logger.info "*** FILE WRITTEN ***"
		else
		   Rails.logger.info "Unable to open file!"
		end
	end

	def delete_svg(record)
		File.delete(svg_path(record)) if File.exist?(svg_path(record))
	end

	def svg_path(record)
		"#{TegrQR::QR_PATH}/#{record.class.name}_#{record.id}.svg"
	end
end
