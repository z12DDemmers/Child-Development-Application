class Subdomain < ActiveRecord::Base
	validates :subdomain, presence: true, uniqueness: true
	validates :subdomain_description, presence:true
end
