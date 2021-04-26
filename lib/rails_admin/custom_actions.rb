require 'rails_admin/config/actions'  
require 'rails_admin/config/actions/base'

require 'time'
require 'zip'

module RailsAdminUploadRecordsAction; end

module RailsAdmin  
  module ApplicationHelper
    def extract_schedule_data
      Spreadsheet.client_encoding = 'UTF-8'
      book = Spreadsheet.open Rails.root.join('public', 'schedule', 'egr_schedule.xls')

      sheet = book.worksheet 'EGR_CIS_CON'
      data = Array.new
      sheet.each do |row|
        next if row[12] == nil or !row[12].include?('TEGR')
        h = Hash.new
        h[:course_code] = row[1]
        h[:section] = row[2]
        h[:title] = row[3]
        h[:professor] = row[5]
        d = []
        if row[9].include?('M')
          d << :monday
        end
        if row[9].include?('T')
          d << :tuesday
        end
        if row[9].include?('W')
          d << :wednesday
        end
        if row[9].include?('R')
          d << :thursday
        end
        if row[9].include?('F')
          d << :friday
        end
        h[:days] = d
        # convert to military time
        times = row[10].split('-')
        t = Hash.new
        start = Time.parse(times[0])
        finish = Time.parse(times[1]) # 12*360
        if start.hour < 7
          start += 12*60*60
        end
        if finish.hour < 8
          finish += 12*60*60 
        end
        t[:start] = start.strftime('%H:%M')
        t[:finish] = finish.strftime('%H:%M')
        h[:time] = t
        h[:room] = row[12]
        data << h
      end

      return data
    end

    def import_updates
      Spreadsheet.client_encoding = 'UTF-8'
      book = Spreadsheet.open Rails.root.join('public', 'schedule', 'egr_records.xls')

      sheet = book.worksheet 0
      data = Array.new
      sheet.each 1 do |row|
        record_data = {}

        record_data[:type] = row[0].classify.constantize
        record_data[:room_code] = row[1]
        record_data[:title] = row[2]
        record_data[:desc] = row[3]

        send("generate_" + row[0].downcase, record_data)
      end
    end

    def generate_room(record_data)
      # update if room exists
      if Room.friendly.exists?(record_data[:room_code].gsub(/ /, "-")) 
        Room.friendly.find(record_data[:room_code].gsub(/ /, "-")).update(name: record_data[:room_code], title: record_data[:title], description: record_data[:desc])
      # create if not
      else
        Room.create(name: record_data[:room_code], title: record_data[:title], description: record_data[:desc]).save
      end
    end

    def generate_display(record_data)
      if Display.friendly.exists?(record_data[:title].gsub(/ /, "-")) 
        Display.friendly.find(record_data[:title].gsub(/ /, "-")).update(title: record_data[:title], description: record_data[:desc])
      # create if not
      else
        Display.create(title: record_data[:title], description: record_data[:desc]).save
      end
    end

    def generate_artifact(record_data)
      if Artifact.friendly.exists?(record_data[:title].gsub(/ /, "-")) 
        Artifact.friendly.find(record_data[:title].gsub(/ /, "-")).update(title: record_data[:title], description: record_data[:desc])
      # create if not
      else
        Artifact.create(title: record_data[:title], description: record_data[:desc]).save
      end
    end

    def generate_rooms(data)
      data.each do |e|
        Room.create(name: e[:room], title: "", description: "").save
      end
    end

    def generate_courses(data)
      data.each do |e|
        course = Course.create(title: e[:title], course_id: "#{e[:course_code]}-#{e[:section]}", instructor: e[:professor], description: "", room_id: Room.friendly.find(e[:room].downcase.gsub(/ /, "-")).id)
        if course.save
          e[:days].each do |day|
            TimeBlock.create(week_day: day, start_time: e[:time][:start], end_time: e[:time][:finish], course_id: course.id)
          end
        end
      end
    end

    class ZipFileGenerator
      # Initialize with the directory to zip and the location of the output archive.
      def initialize(input_dir, output_file)
        @input_dir = input_dir
        @output_file = output_file
      end

      # Zip the input directory.
      def write
        entries = Dir.entries(@input_dir) - %w[. ..]

        ::Zip::File.open(@output_file, ::Zip::File::CREATE) do |zipfile|
          write_entries entries, '', zipfile
        end
      end

      private

      # A helper method to make the recursion work.
      def write_entries(entries, path, zipfile)
        entries.each do |e|
          zipfile_path = path == '' ? e : File.join(path, e)
          disk_file_path = File.join(@input_dir, zipfile_path)

          if File.directory? disk_file_path
            recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
          else
            put_into_archive(disk_file_path, zipfile, zipfile_path)
          end
        end
      end

      def recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
        zipfile.mkdir zipfile_path
        subdir = Dir.entries(disk_file_path) - %w[. ..]
        write_entries subdir, zipfile_path, zipfile
      end

      def put_into_archive(disk_file_path, zipfile, zipfile_path)
        zipfile.add(zipfile_path, disk_file_path)
      end
    end

    def zip_qr_codes
      zip_path = File.join(Rails.root, 'public', 'qr_codes.zip')

      File.delete(zip_path) if File.exist?(zip_path)

      zf = ZipFileGenerator.new("#{Rails.root}/app/assets/images/qr_codes", zip_path)
      zf.write()
    end

    def qr_code(url)
      qrcode = RQRCode::QRCode.new(url)

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

      return png
    end
  end

  module Config
    module Actions
      class CustomAction < RailsAdmin::Config::Actions::Base
        register_instance_option :pjax? do
          false
        end

        register_instance_option :root? do
          true
        end
      end

      class BulkScheduleImport < CustomAction
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :link_icon do
          # font awesome icons. but an older version
          'icon-envelope' 
        end
      end

      class UploadRecords < CustomAction
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          false
        end

        register_instance_option :show_in_navigation do
          false
        end
        
        register_instance_option :http_methods do
          [:post]
        end

        register_instance_option :controller do
          proc do
            flash[:notice] = "File received!"
            uploaded_io = params[:schedule_sheet]
            File.open(Rails.root.join('public', 'schedule', 'egr_schedule.xls'), 'wb') do |file|
              file.write(uploaded_io.read)
            end

            flash[:notice] = "Beginning import"
            egr_records = extract_schedule_data

            generate_rooms(egr_records)
            generate_courses(egr_records)

            redirect_to dashboard_path
          end
        end
      end

      class DownloadRecords < CustomAction
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          false
        end

        register_instance_option :show_in_navigation do
          false
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          proc do
            send_file File.join(Rails.root, 'public', 'schedule', 'egr_schedule.xls')
          end
        end
      end

      class UploadUpdates < CustomAction
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          false
        end

        register_instance_option :show_in_navigation do
          false
        end
        
        register_instance_option :http_methods do
          [:post]
        end

        register_instance_option :controller do
          proc do
            flash[:notice] = "File received!"
            uploaded_io = params[:update_sheet]
            File.open(Rails.root.join('public', 'schedule', 'egr_records.xls'), 'wb') do |file|
              file.write(uploaded_io.read)
            end

            flash[:notice] = "Beginning import"
            egr_records = import_updates
            redirect_to dashboard_path
          end
        end
      end

      class DownloadUpdateSheet < CustomAction
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          false
        end

        register_instance_option :show_in_navigation do
          false
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          proc do
            send_file File.join(Rails.root, 'public', 'schedule', 'egr_records.xls')
          end
        end
      end

      class DownloadQrCodes < CustomAction
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          false
        end

        register_instance_option :show_in_navigation do
          false
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          proc do
            zip_qr_codes
            send_file File.join(Rails.root, 'public', 'qr_codes.zip')
          end
        end
      end

      class DownloadQrCode < CustomAction
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          false
        end

        register_instance_option :show_in_navigation do
          false
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          proc do
            send_file File.join(Rails.root, 'public', 'qr_code.png')
          end
        end
      end

      class GenerateQrCode < CustomAction
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          false
        end

        register_instance_option :show_in_navigation do
          false
        end

        register_instance_option :http_methods do
          [:post]
        end

        register_instance_option :controller do
          proc do
            IO.binwrite(File.join(Rails.root, 'public', 'qr_code.png'), qr_code(params[:URL]).to_s)
          end
        end
      end

      class DeleteAllRecords < CustomAction
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :visible? do
          false
        end

        register_instance_option :show_in_navigation do
          false
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          proc do
            Display.destroy_all
            TimeBlock.destroy_all
            Course.destroy_all
            Room.destroy_all
            Artifact.destroy_all
            redirect_to dashboard_path
          end
        end
      end
    end
  end
end  


