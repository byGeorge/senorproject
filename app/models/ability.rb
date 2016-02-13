
class Ability < ActiveRecord::Base

	def generate(totpoints)
		base = (totpoints/7).to_i
		flux = totpoints - (base*6)
		toAdd = [0,0,0,0,0,0]
		while (flux > 0)
			toAdd[blah = rand(6)] += 1
			flux-=1
		end
		@str = 0 + base + toAdd[0]
		@dex = 0 + base + toAdd[1]
		@con = 0 + base + toAdd[2]
		@int = 0 + base + toAdd[3]
		@wis = 0 + base + toAdd[4]
		@cha = 0 + base + toAdd[5]
	end

	def get_str
		@str
	end

	def get_dex
		@dex
	end

	def get_con
		@con
	end

	def get_int
		@int
	end

	def get_wis
		@wis
	end

	def get_cha
		@cha
	end

end
