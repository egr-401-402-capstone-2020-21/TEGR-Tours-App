module RoomsHelper
	def render_svg(room_id)
		# TODO abstract to lib to reduce redundancy
	  file_path = "#{Rails.root}/app/assets/images/qr_codes/room_#{room_id}.svg"
	  return File.read(file_path).html_safe if File.exists?(file_path)
	  '(not found)'
	end
end
