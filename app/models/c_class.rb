class CClass < ActiveRecord::Base
	def self.pickme
		CClass.find_by_name("Random")
	end
end
