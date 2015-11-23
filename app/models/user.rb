class User < ActiveRecord::Base
	has_many :children
	has_secure_password
	validates :username, :email, presence: true
end