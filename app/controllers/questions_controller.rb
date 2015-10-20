class QuestionsController < ActionController::Base
	def survey
	  @question = question.where('minimum_age_to_ask < ? and maximum_age_to_ask > ?',  CHILD_AGE)
	end
	
	def answer
	  answer_array = answer_array + [params[:question_id],params[:answer],params[:age_at_which_goal_was_met]]
	end
end