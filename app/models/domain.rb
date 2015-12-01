class Domain < ActiveRecord::Base
	validates :domain, presence: true, uniqueness: true
	has_many :subdomains
end