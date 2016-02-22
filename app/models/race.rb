class Race < ActiveRecord::Base
	def self.pickme
		Race.find_by_name("Random")
	end
end
