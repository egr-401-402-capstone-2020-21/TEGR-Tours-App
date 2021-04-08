class ApplicationController < ActionController::Base
	module TegrQR
		DOMAIN = "http://tegrtours.com"
		QR_PATH = "#{Rails.root}/app/assets/images/qr_codes"
	end

	def save_svg(svg, room_id)
		file_path = "#{TegrQR::QR_PATH}/room_#{room_id}.svg"

		aFile = File.new(file_path, "w")
		if aFile
		   aFile.syswrite(svg)
		else
		   Rails.logger.info "Unable to open file!"
		end
	end
end
