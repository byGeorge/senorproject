class DwarfName < ActiveRecord::Base
	self.primary_key = "nid"

	def self.choosename
		names = DwarfName.all
		lname = names.sample.name + names.sample.name.downcase
		name = names.sample.name + lname.gsub(" ", "")
	end
end
