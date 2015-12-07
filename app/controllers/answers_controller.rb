class AnswersController < ApplicationController
	def create
		Answer.create(answer_params)
=begin
	Some really bad coding, the datatype of the session variable is lost
	through requests and the response can only be seen here to see if
	we increase the yes_count of the AssessmentQueue. So I will have to
	modify the hash that AssessmentQueue becomes to increase the yes_count.
=end
		if params[:answer_of_child][:response] == "true"
			#Code violates DRY fix later.
		  session[params[:answer_of_child][:child_id].to_sym][(params[:answer_of_child][:domain_name].downcase.tr(" ","_") + "_queue")]["yes_count"] += 1
			session[params[:answer_of_child][:child_id].to_sym][(params[:answer_of_child][:domain_name].downcase.tr(" ","_") + "_queue")]["last_response"] = 1
		else
			session[params[:answer_of_child][:child_id].to_sym][(params[:answer_of_child][:domain_name].downcase.tr(" ","_") + "_queue")]["last_response"] = 0
		end
		redirect_to params[:answer_of_child][:previous]
	end
	
	private
	
	def answer_params
		params.require(:answer_of_child).permit(:response, :question_id,:child_id)
	end
end
