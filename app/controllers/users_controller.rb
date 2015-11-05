class UsersController < ApplicationController
	def new
		@user = User.new
	end
	
	def create
		@user = User.create(user_params)
		redirect_to @user
	end
	
	def show
		@user = User.find(params[:id])
		@children = Child.where(user_id: params[:id])
	end
	private
	
	def user_params
		params.require(:user).permit(:username, :email, :password, :password_confirmation)
	end
	
end
