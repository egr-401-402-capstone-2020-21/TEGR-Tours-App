require 'rails_admin/config/actions'  
require 'rails_admin/config/actions/base'

#require 'spreadsheet'
require 'time'

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
        d = Hash.new
        if row[9].include?('M')
          d[:M] = true
        end
        if row[9].include?('T')
          d[:T] = true
        end
        if row[9].include?('W')
          d[:W] = true
        end
        if row[9].include?('R')
          d[:R] = true
        end
        if row[9].include?('F')
          d[:F] = true
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

    def generate_rooms(data)
      data.each do |e|
        Room.create(name: e[:room], title: "", description: "").save
      end
    end

    def generate_courses(data)
      data.each do |e|
        Course.create(title: e[:title], course_id: e[:course_code], instructor: e[:professor], description: "", room_id: Room.friendly.find(e[:room].downcase.gsub(/ /, "-")).id).save
      end
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
            uploaded_io = params[:schedule_sheet]
            File.open(Rails.root.join('public', 'schedule', 'egr_schedule.xls'), 'wb') do |file|
              file.write(uploaded_io.read)
            end

            egr_records = extract_schedule_data

            generate_rooms(egr_records)
            generate_courses(egr_records)
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
            #send_file File.join(Rails.root, 'public', 'schedule', 'egr_schedule.xls')
          end
        end
      end

    end
  end
end  


