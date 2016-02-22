class HumanName < ActiveRecord::Base

	def self.choosename(m, f, n)
		names = HumanName.all
		fname = HumanName.genderlimit(m, f, n)
		name = fname.sample.first_name + " " + names.sample.last_name.gsub(" ", "")
		name = name + ", \"" + names.sample.nickname + "\"" if (rand(10) == 1)
		name
	end

	def self.genderlimit(m, f, n)
		names = HumanName.all
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

