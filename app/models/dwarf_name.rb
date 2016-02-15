class DwarfName < ActiveRecord::Base
	self.primary_key = "nid"

	def self.choosename
		names = DwarfName.all
		name = names.sample.fname + names.sample.clan_name
	end
end
