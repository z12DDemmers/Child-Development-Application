class Subdomain < ActiveRecord::Base
	belongs_to :domain
	has_many :questions
	validates :subdomain, presence: true, uniqueness: true
	validates :subdomain_description, presence:true
end
