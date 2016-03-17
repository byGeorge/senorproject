class DwarfName < ActiveRecord::Base

	def self.choosename(m, f, n)
		names = DwarfName.all
		fname = DwarfName.genderlimit(m, f, n)
		name = fname.sample.fname + " " + names.sample.clan_name + names.sample.clan_name
	end

	def self.genderlimit(m, f, n)
		names = DwarfName.all
		list = []
		if (!m && !f && !n) || (m && f && n)
			list = names
		else
			names.each do |name|
				marker = name.gender
				list.push name if (m && marker == 'm')
				list.push name if (f && marker == 'f')
				list.push name if (n && marker == 'n')
			end			
		end
		list
	end
end
