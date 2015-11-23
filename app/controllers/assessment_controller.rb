require "#{Rails.root}/lib/assessment_queue.rb" 
class AssessmentController < ApplicationController
	#Lots of redundancy or what feels like needless recalculation.  Refactor or something later.
	#There seems to be a lot of what, to me, feels like bad or wrong practices here too.
  def gross_motor
		#Will probably be rolled into one function so it can be used in every
		#domain action to keep with Rails' DRY principle.
		#To shorten code.  domain_queue is NOT a copy as I understand it, but a reference.
		session[:gross_motor_queue] ||= AssessmentQueue.new("Gross Motor")
		domain_queue = session[:gross_motor_queue]
		@child = Child.find(params[:child_id])
		if(domain_queue.finished_domain?)
			score_domain(domain_queue.get_domain)
    elsif(domain_queue.is_empty?)
			questions = Question.joins(:subdomain) \
			.where(:subdomains =>{:subdomain => domain_queue.current_subdomain}).limit(4) #\
			#.where("? - 3 >= minimum_age_to_ask AND ? <= maximum_age_to_ask",child.developmental_age,child.developmental_age)
			if(domain_queue.enqueue(questions))
			elsif #Can't retrieve more questions, score the subdomain.
				score_subdomain(domain_queue.move_to_next_subdomain)
				redirect_to gross_motor
			end
		end
		@question = domain_queue.dequeue
		@answer = Answer.new
  end
	
	private
		#all (sub)domain score database attributes are the downcased, underscore separated
		#version of their respective names appended with "_score"
		def string_to_database_attribute(string) #bad practice?
			string.downcase.tr(" ","_") + "_score"
		end
		
		def score_subdomain(subdomain)
			subdomain_symbol = string_to_database_attribute(subdomain)
=begin
				The subdomain scores should be the minimum_age_to_ask of the answers which is acquired
				by getting the subdomain id field, getting all questions associated with that subdomain id,
				and joining those questions with the answers table and keeping only those which have an answer
				for that particular id and ones answered only by the current child.
=end
			subdomain_answers = Question.select("minimum_age_to_ask").joins(:subdomain) \
			.where(:subdomains =>{:subdomain => subdomain}).joins(:answers) \
			.where(:answers =>{:child_id => params[:child_id]})
			min = 1000
			#Probably a better way to do this below.
			subdomain_answers.each do |subdomain_answer|
				if(subdomain_score[:minimum_age_to_ask] < min)
					min = subdomain_answers[:minimum_age_to_ask]
				end
			end
			child = Child.find(params[:child_id])
			child.update(subdomain_symbol => min)
			
		end
		
		def score_domain(domain)
			child = Child.find(params[:child_id])
			domain_symbol = string_to_database_attribute(domain)
			#fetches subdomains of a domain again...
			subdomains = Subdomain.select("subdomain").joins(:domain).where(:domains => {:domain => domain})
			#gets rid of all the other fluff that comes with active record, leaves only strings of subdomain names
			subdomains = subdomains.map{|score| string_to_database_attribute(score[:subdomain])}
			subdomain_scores = []
			subdomains.each do |subdomain|
				subdomain_scores += child[subdomain]
			end
			subdomain_scores = subdomain_scores.sort
			mid = subdomain_scores.length / 2
			child.update(domain_symbol => subdomain_scores.length.odd? ? subdomain_scores[mid] : 0.5 * (subdomain_scores[mid] + subdomain_scores[mid - 1]))
			#redirect_to gross_motor_score page
		end
end