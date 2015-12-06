module ApplicationHelper
	def logged_in?
		if(session[:user_id])
		else
			redirect_to root_path
		end
	end
end
