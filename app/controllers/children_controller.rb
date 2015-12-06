class ChildrenController < ApplicationController
=begin
  def new
	@user = User.find(params[:user_id])
	@child = Child.new
  end
=end 
  def show
	
  end
	
  def create
	@user = User.find(params[:user_id])
	Child.create(child_params)
	redirect_to @user
  end
	
  def edit
	@user = User.find(params[:user_id])
	@child = Child.find(params[:id])
  end
	
  def update
	
  end
	
  def destroy
    user = User.find(params[:user_id])
    child = Child.find(params[:id])
		answers_of_child = Answer.where(:child_id => child.id)
		answers_of_child.each do |answer_of_child|
			answer_of_child.destroy
		end
    child.destroy
		redirect_to user and return
  end
  
  private
  
    def child_params
      params.require(:child_of_user).permit(:name,:age,:user_id)
    end
end
