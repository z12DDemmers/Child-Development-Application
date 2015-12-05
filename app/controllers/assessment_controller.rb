class AssessmentController < ApplicationController
	#Lots of redundancy or what feels like needless recalculation.  Refactor or something later.
	#There seems to be a lot of what, to me (Nav), feels like bad or wrong practices here too.
	#Use devise gem later for easier authentication handling/web page choosing as well
		#i.e. what pages to show for a logged in and not logged in user
	def home
		reset_session
		@children = nil
		@children_links = [] #Holds links for javascript manipulation.
		session[:user_id] = 3
		if session[:user_id]
			@children = Child.joins(:user).where(:users =>{:id => session[:user_id]})
			@children.each do |child| #Add links, there will be 6 per child eventually.
				@children_links += [child_gross_motor_path(child)] 
			end
		end
	end
	
	def delete_answers
		reset_session
		Answer.delete_all
		redirect_to root_path and return
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
			redirect_to child_gross_motor_score_path(@child) and return
    elsif domain_queue.is_empty?
			if domain_queue.get_last_response == 0 #include < 2 age check to score sub_domain
				@child.developmental_age -= 2.0
				@child.save
			end
			#get questions and convert to array
			temp = Question.select("id").joins(:subdomain) \
			.where(:subdomains =>{:subdomain => domain_queue.current_subdomain}) \
			.where("? > minimum_age_to_ask",@child.developmental_age) \
			.where("questions.id not in (?)", Answer.select("question_id").joins(:child).where("children.id == ?", params[:child_id])).to_a
			#Extract only the id data, numbers, from the questions cause of session hash issues with AssessmentQueue
			questions = []
			temp.each_with_index do |question, index|
				questions[index] = question.id
			end
			if domain_queue.enqueue(questions)
			else #Can't retrieve more questions, score the subdomain.
				score_subdomain(domain_queue.move_to_next_subdomain)
				redirect_to child_gross_motor_path(@child) and return
			end
		end
		@question = Question.find(domain_queue.dequeue)
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
		end
end