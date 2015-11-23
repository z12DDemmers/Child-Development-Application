class AssessmentQueue
  def initialize(domain_name)
    @question_queue = []
		@subdomains = ["Prone","Supine","Responses","Reflexes","Sitting","Standing","Mobility","Throwing and Catching"]
		@yes_count = 0
		@domain = domain_name
  end
  
  def enqueue(question_set)
    if(question_set.empty?) 
		  return false
		end
		@question_queue = question_set.to_a
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
end