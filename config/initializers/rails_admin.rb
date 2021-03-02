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
      class BulkScheduleImport < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :root? do
          true
        end

        register_instance_option :visible? do
          true
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          proc do
          end
        end

        register_instance_option :link_icon do
          # font awesome icons. but an older version
          'icon-envelope' 
        end
      end

      class UploadRecords < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :root? do
          true
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

      class DownloadRecords < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :root? do
          true
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          proc do
            #send_file File.join(Rails.root, 'public', 'schedule', 'egr_schedule.xls')
            egr_records = extract_schedule_data
            Rails.logger.info egr_records
            generate_rooms(egr_records)
            generate_courses(egr_records)
          end
        end
      end

    end
  end
end  


RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true
  config.authorize_with do
    redirect_to main_app.root_path unless warden.user.admin?
  end
  
  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    bulk_schedule_import
    upload_records
    download_records



    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Room' do
    create do
      field :name
      field :title
      field :description
      field :courses
    end
  end
end
