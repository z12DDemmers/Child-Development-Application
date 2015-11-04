class ChildrenController < ApplicationController
  def new
	@user = User.find(params[:user_id])
	@child = Child.new
  end
  
  def show
	
  end
	
  def create
	
  end
	
  def edit
	
  end
	
  def update
	
  end
	
  def destroy
	
  end
end
