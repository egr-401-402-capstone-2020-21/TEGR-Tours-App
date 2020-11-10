class UserSessionsController < ApplicationController
<<<<<<< HEAD
  skip_before_action :authorized, only: [:new, :create, :welcome]
  
=======
>>>>>>> master
  def new
  end

  def create
<<<<<<< HEAD
	@user = User.find_by(email: params[:email])
	if @user && @user.authenticate(params[:password])
		session[:user_id] = @user.id
		redirect_to '/welcome'
	else
		redirect_to '/login'
	end
=======
>>>>>>> master
  end

  def destroy
  end
<<<<<<< HEAD

  def login
  end
	
  def welcome
  end

  def page_requires_login
  end
=======
>>>>>>> master
end
