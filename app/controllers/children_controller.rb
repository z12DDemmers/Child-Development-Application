class ChildrenController < ApplicationController
  def new
	@user = User.find(params[:user_id])
	@child = Child.new
  end
  
  def show
	
  end
	
  def create
	@user = User.find(params[:user_id])
	Child.create(child_params)
	redirect_to @user
  end
	
  def edit
	
  end
	
  def update
	
  end
	
  def destroy
	
  end
  
  private
  
    def child_params
      params.require(:child_of_user).permit(:name,:age,:user_id)
    end
end
