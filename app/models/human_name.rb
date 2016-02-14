class HumanName < ActiveRecord::Base
	self.primary_key = "nid"

	def self.pickme
		HumanName.find_by_name("Random")
	end

	def self.choosename
		names = HumanName.all
		name = names.sample.first_name + " " + names.sample.last_name
		name = name + ", \"" + names.sample.nickname + "\"" if (rand(10) == 1)
		name
	end
end
