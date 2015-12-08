module AssessmentHelper
	def evaluate_domain(domain,domain_link,domain_score_link, child_id)
		domain_symbol = (domain.downcase.tr(" ","_") + "_queue").to_sym
		child_symbol = child_id.to_s.to_sym
		@user = User.find(session[:user_id])
		session[child_symbol] ||= {domain_symbol => AssessmentQueue.new(domain)}
		if(session[child_symbol][domain_symbol].class != AssessmentQueue)
			session[child_symbol][domain_symbol] = reinitialize_queue(session[child_symbol][domain_symbol.to_s])
		end
		domain_queue = session[child_symbol][domain_symbol]
		@child = Child.find(params[:child_id])
		@domain_name = domain_queue.get_domain
		if domain_queue.get_yes_count == 3
			domain_queue.reset_yes_count
			score_subdomain(domain_queue.move_to_next_subdomain)
			
			redirect_to domain_link and return
		elsif domain_queue.finished_domain?
			score_domain(domain_queue.get_domain)
			redirect_to domain_score_link and return
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
				redirect_to domain_link and return
			end
		end
		@question = Question.find(domain_queue.dequeue)
		@answer = Answer.new
		return @user,@child,@domain_name,@question,@answer
	end
	#all (sub)domain score database attributes are the downcased, underscore separated
	#version of their respective names appended with "_score"
	def string_to_database_attribute(string) #bad practice?
		(string.downcase.tr(" ","_").tr("-","_").tr(",","_") + "_score").to_sym
	end
	
	def reinitialize_queue(dq)
		AssessmentQueue.new(dq["domain"],dq["question_queue"],dq["subdomains"],dq["yes_count"],dq["last_response"],true)
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
		min = -1
		#Probably a better way to do this than below.
		subdomain_answers.each do |subdomain_answer|
			if(subdomain_answer[:minimum_age_to_ask] > min)
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
		
	def child_belongs_to_user?(child_id)
		child = Child.find(child_id)
		if child.user_id != session[:user_id]
			flash[:error] = "You are not authorized to view this page."
			redirect_to root_path and return
		else
			true
		end
	end
end
