class AssessmentController < ApplicationController
	#Lots of redundancy or what feels like needless recalculation.  Refactor or something later.
	#There seems to be a lot of what, to me (Nav), feels like bad or wrong practices here too.
	#Use devise gem later for easier authentication handling/web page choosing as well
		#i.e. what pages to show for a logged in and not logged in user
	def home
		reset_session
		@children = nil
		@children_links = [] #Holds links for javascript manipulation.
		session[:user_id] = 6
		if session[:user_id]
			@children = Child.joins(:user).where(:users =>{:id => session[:user_id]})
			@children.each do |child| #Add links, there will be 6 per child eventually.
				@children_links += [child_gross_motor_path(child)] 
			end
		end
	end
	
  def gross_motor
		#Will probably be rolled into one function so it can be used in every
		#domain action to keep with Rails' DRY principle.
		
		session[:gross_motor_queue] ||= AssessmentQueue.new("Gross Motor")
		if(session[:gross_motor_queue].class != AssessmentQueue)
		  session[:gross_motor_queue] = reinitialize_queue(session[:gross_motor_queue])
		end
		domain_queue = session[:gross_motor_queue]
		@child = Child.find(params[:child_id])
		@domain_name = domain_queue.get_domain
		if domain_queue.get_yes_count == 3
			score_subdomain(domain_queue.move_to_next_subdomain)
			redirect_to child_gross_motor_path(@child)
		elsif domain_queue.finished_domain?
			score_domain(domain_queue.get_domain)
			redirect_to child_gross_motor_score_path(@child)
    elsif domain_queue.is_empty?
			if domain_queue.get_last_response == 0 #include < 2 age check to score sub_domain
				@child.developmental_age -= 2.0
				@child.save
			end
=begin
	Question query below:  Get the id (id only due to size limit of session hash)
	of all questions that belong to the current subdomain where the developmental age
	of the child is greater than or equal to Question.minimum_age_to_ask and where
	the question hasn't been answered yet.
	*Note - has to be modified to include questions that recieved a no response that 
	 have not been asked in a certain timeframe.
=end
			questions = Question.select("id").joins(:subdomain) \
			.where(:subdomains =>{:subdomain => domain_queue.current_subdomain}) \
			.where("? < minimum_age_to_ask",@child.developmental_age) \
			.where("questions.id not in (?)", Answer.select("question_id").joins(:child).where("children.id == ?", params[:child_id]))
			if domain_queue.enqueue(questions.to_a)
			
			elsif #Can't retrieve more questions, score the subdomain.
				score_subdomain(domain_queue.move_to_next_subdomain)
				redirect_to child_gross_motor_path(@child)
			end
		end
		@question = Question.find((domain_queue.dequeue).id)
		@answer = Answer.new
  end
	
	def gross_motor_score
		@child = Child.find(params[:child_id])
	end
	
	private
		#all (sub)domain score database attributes are the downcased, underscore separated
		#version of their respective names appended with "_score"
		def string_to_database_attribute(string) #bad practice?
			(string.downcase.tr(" ","_") + "_score").to_sym
		end
		
		def reinitialize_queue(dq)
			AssessmentQueue.new(dq["domain"],dq["question_queue"],dq["subdomains"],dq["yes_count"],dq["last_response"])
		end
		
		def score_subdomain(subdomain)
			subdomain_symbol = string_to_database_attribute(subdomain)
			child = Child.find(params[:child_id])
=begin
				The subdomain scores should be the minimum_age_to_ask of the answers which is acquired
				by getting the subdomain id field, getting all questions associated with that subdomain id,
				and joining those questions with the answers table and keeping only those which have an answer
				for that particular id and ones answered only by the current child.
=end
			subdomain_answers = Question.select("minimum_age_to_ask").joins(:subdomain) \
			.where(:subdomains =>{:subdomain => subdomain}).joins(:answers) \
			.where(:answers =>{:child_id => params[:child_id]}).to_a
			#If no subdomain questions were asked, the score is 0 and not considered in the domain score
			if subdomain_answers == []
				child.update(subdomain_symbol => 0)
				return
			end
			min = 1000
			#Probably a better way to do this than below.
			subdomain_answers.each do |subdomain_answer|
				if(subdomain_answer[:minimum_age_to_ask] < min)
					min = subdomain_answer[:minimum_age_to_ask]
				end
			end
			child.update(subdomain_symbol => min)
		end
		
		def score_domain(domain)
			child = Child.find(params[:child_id])
			domain_symbol = string_to_database_attribute(domain)
			#fetches subdomains of a domain again...
			subdomains = Subdomain.select("subdomain").joins(:domain).where(:domains => {:domain => domain})
			#gets rid of all the other fluff that comes with active record, leaves only strings of subdomain names
			#subdomains = subdomains.map{|score| string_to_database_attribute(score[:subdomain])}
			subdomain_scores = []
			subdomains.each do |subdomain|
				subdomain_scores += [child[string_to_database_attribute(subdomain[:subdomain])]]
			end
			subdomain_scores = subdomain_scores.sort
			mid = subdomain_scores.length / 2
			child.update(domain_symbol => subdomain_scores[mid] )
			#redirect_to gross_motor_score page
		end
end