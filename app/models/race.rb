
class Race < ActiveRecord::Base
	self.primary_key = "RID"
	puts(Race.all.count)
	puts("RaceModel working. I hope.") 
	@races = Race.all
end
