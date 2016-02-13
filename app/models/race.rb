
class Race < ActiveRecord::Base
	self.primary_key = "rid"

	def self.pickme
		return Race.find_by_name("Random")
	end
end
