require 'rails_admin/config/actions'  
require 'rails_admin/config/actions/base'

module RailsAdminUploadRecordsAction; end

module RailsAdmin  
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
            if request.get?
            end
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
            if request.post?
            end
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
            if request.get?
            end
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
