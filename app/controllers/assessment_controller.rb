class AssessmentController < ApplicationController
	include AssessmentHelper
	before_action :authenticated?, only: [:gross_motor,:gross_motor_score]
	#Lots of redundancy or what feels like needless recalculation.  Refactor or something later.
	#There seems to be a lot of what, to me (Nav), feels like bad or wrong practices here too.
	#Use devise gem later for easier authentication handling/web page choosing as well
		#i.e. what pages to show for a logged in and not logged in user
	def home
		if(session[:user_id])
			@user = User.find(session[:user_id])
			@children = nil
			@children_links = [] #Holds links for javascript manipulation.
			@children = Child.joins(:user).where(:users =>{:id => session[:user_id]})
			@children.each do |child| #Add links, there will be 6 per child eventually.
				@children_links += [[child_gross_motor_path(child),child_cognitive_path(child),child_receptive_language_path(child)]]
			end
		end
		@child = Child.new
	end
	
	def delete_answers
		reset_session
		Answer.delete_all
		redirect_to root_path and return
	end
	
	def gross_motor
		child_belongs_to_user?(params[:child_id])
		child = Child.find(params[:child_id]) #redundant?
		@user,@child,@domain_name,@question,@answer = evaluate_domain("Gross Motor",child_gross_motor_path(child),child_gross_motor_score_path(child),child.id)
	end
	
	def cognitive
		child_belongs_to_user?(params[:child_id])
		child = Child.find(params[:child_id]) #redundant?
		@user,@child,@domain_name,@question,@answer = evaluate_domain("Cognitive",child_cognitive_path(child),child_cognitive_score_path(child),child.id)
	end
	
	def receptive_language
		child_belongs_to_user?(params[:child_id])
		child = Child.find(params[:child_id]) #redundant?
		@user,@child,@domain_name,@question,@answer = evaluate_domain("Cognitive",child_receptive_language_path(child),child_receptive_language_score_path(child),child.id)
	end
	
	def gross_motor_score
		child_belongs_to_user?(params[:child_id])
		@user = User.find(session[:user_id])
		@child = Child.find(params[:child_id])
	end
	
	def cognitive_score
		child_belongs_to_user?(params[:child_id])
		@user = User.find(session[:user_id])
		@child = Child.find(params[:child_id])
	end
	
	def receptive_language_score
		child_belongs_to_user?(params[:child_id])
		@user = User.find(session[:user_id])
		@child = Child.find(params[:child_id])
	end
	
end