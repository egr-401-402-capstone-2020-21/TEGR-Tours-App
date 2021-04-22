# This is the path to the custom actions that parse the EGR Master Spreadsheet
require Rails.root.join('lib', 'rails_admin', 'custom_actions.rb')

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
    redirect_to main_app.root_path unless warden.user and warden.user.admin?
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

    # Custome Actions
    bulk_schedule_import
    upload_records
    download_records
    upload_updates
    download_update_sheet
    download_qr_codes
    download_qr_code
    generate_qr_code
    delete_all_records
  end

  config.model 'Room' do
    create do
      field :name
      field :title
      field :description
      field :courses
    end
  end

  config.model 'Course' do
    create do
      field :room
      field :title
      field :course_id
      field :instructor
      field :description
    end
  end

  config.model 'Display' do
    create do
      field :title
      field :description
    end
  end

  config.model 'Artifact' do
    create do
      field :title
      field :description
    end
  end

  config.model 'TimeBlock' do
    visible false
  end

  config.model 'User' do
    create do
      field :admin
      field :email
      field :password
      field :password_confirmation
    end
  end
end
