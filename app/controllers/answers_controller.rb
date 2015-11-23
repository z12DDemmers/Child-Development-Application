class AnswersController < ApplicationController
	def create
		Answer.create(answer_params)
		redirect_to gross_motor_path
		#redirect_to params[:answer][:back]
	end
	
	private
	
	def answer_params
		params.require(:answer_of_child).permit(:response, :question_id)
	end
	
end
