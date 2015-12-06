module ApplicationHelper
	def authenticated?
		if(session[:user_id])
		else
			redirect_to root_path
		end
	end
	
	def logged_in?
		if(session[:user_id])
			true
		else
			false
		end
	end
end
