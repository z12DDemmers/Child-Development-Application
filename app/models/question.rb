class Question < ActiveRecord::Base
	belongs_to :subdomain
	has_many :answers
	validates :question, presence: true, uniqueness: true
	validates :description,:minimum_age_to_ask,:maximum_age_to_ask, presence: true
end