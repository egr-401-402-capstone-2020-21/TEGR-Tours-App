module ApplicationHelper
	def render_svg(record)
		# TODO abstract to lib to reduce redundancy
	  file_path = "#{Rails.root}/app/assets/images/qr_codes/#{record.class.name}_#{record.id}.svg"
	  return File.read(file_path).html_safe if File.exists?(file_path)
	  '(not found)'
	end
end
