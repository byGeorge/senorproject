
class Race < ActiveRecord::Base
	self.primary_key = "rid"

	def self.pickme
		Race.find_by_name("Random")
	end
end
