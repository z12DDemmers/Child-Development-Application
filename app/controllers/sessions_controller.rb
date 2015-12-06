class SessionsController < ApplicationController
  def new
		if logged_in?
			flash[:success] = "You are already logged in."
			redirect_to root_path and return
		end
  end
  
  def create
	user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
		reset_session
		flash[:success] = "You have been successfully logged out."
		redirect_to root_path and return
  end
end
