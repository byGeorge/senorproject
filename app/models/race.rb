
class Race < ActiveRecord::Base
	self.primary_key = "RID"
	@races = Race.all
	def print_name
		name
	end
end
