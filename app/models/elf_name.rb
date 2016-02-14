class ElfName < ActiveRecord::Base
	self.primary_key = "nid"

	def self.choosename
		names = ElfName.all
		syll = ElfSyllable.all
		fname = syll.sample.syllable.capitalize
		for i in 1..(rand(3))
			fname = fname + syll.sample.syllable
		end
		name =  fname + " " + names.sample.name
	end
end
