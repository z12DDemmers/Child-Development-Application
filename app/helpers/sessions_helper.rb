module SessionsHelper
  def log_in(user)
    sessions[:user_id] = user.id
		sessions[:gross_motor_queue] = AssessmentQueue.new
  end
end
