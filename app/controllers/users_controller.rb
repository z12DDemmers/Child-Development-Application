class UsersController < ApplicationController
	before_action :authenticated?, only: [:show]
	def new
		@user = User.new
	end
	
	def create
		@user = User.create(user_params)
		log_in(@user)
		redirect_to @user
	end
	
	def show
		@user = User.find(params[:id])
		@children = Child.where(user_id: params[:id])
		@child = Child.new
		
	end
	private
	
	def user_params
		params.require(:user).permit(:username, :email, :password, :password_confirmation)
	end
	
end
