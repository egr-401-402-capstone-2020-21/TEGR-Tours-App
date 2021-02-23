class ApplicationRecord < ActiveRecord::Base
  	self.abstract_class = true
	module TegrQR
		DOMAIN = "http://10.147.19.131:3001"
		QR_PATH = "#{Rails.root}/app/assets/images/qr_codes"
	end

	def save_svg(svg, model_name, record_id)
		file_path = "#{TegrQR::QR_PATH}/#{model_name}_#{record_id}.svg"

		aFile = File.new(file_path, "w")
		if aFile
		   aFile.syswrite(svg)
		else
		   Rails.logger.info "Unable to open file!"
		end
	end
end
