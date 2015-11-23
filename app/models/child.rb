class Child < ActiveRecord::Base
	belongs_to :user
	before_create do #set developmental_age based on real age
		self.developmental_age = self.age - 2
	end
end