class AssessmentQueue
=begin
	Temporary solution until a better method is found out. The session hash is 
	only capable of storing JSON format and thus the data type is lost across requests
	and so the object has to be reinitialized wherever it is used.
=end
	def initialize(domain_name, question_set = [],subdomains = [], y_count = 0, last_response = 0, previously_initialized = false)
		@question_queue = question_set
		@subdomains = subdomains
		if !previously_initialized
			temp = Subdomain.select("subdomain").joins(:domain).where(:domains =>{:domain => domain_name}).to_a
			temp.each_with_index do |subdom, index|
				@subdomains[index] = subdom.subdomain
			end
		end
		@domain = domain_name
		@yes_count = y_count
		@last_response = last_response
		#add Developmental Age here.
	end
  
  def enqueue(question_set)
    if question_set.empty?
		  return false
		end
		@question_queue = question_set
		return true
  end
  
  def dequeue
    @question_queue.shift
  end
  
  def is_empty?
    @question_queue.empty?
  end
	
	def current_subdomain
		@subdomains[0]
	end
	
	def finished_domain?
		@subdomains.empty?
	end
	
	def move_to_next_subdomain #make private?
	  @subdomains.shift
	end
	
	def set_subdomains(subdomains)
		@subdomains = subdomains
	end
	
	def get_current_subdomain
		@subdomains[0]
	end
	
	def get_domain
		@domain
	end
	def get_last_response
		@last_response
	end
	def get_yes_count
		@yes_count
	end
	
	def reset_yes_count
		@yes_count = 0
	end
end