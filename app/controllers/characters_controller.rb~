class CharactersController < ApplicationController

	def login
	end

	def get_race
		@race
	end

	def post
		
	end

	def show
		
	end

	def preview
		race_id_temp = params[:race][:race_id].to_i
		@race = Race.find_by_rid(race_id_temp)
		if random?(@race)
			@race = Race.where.not(rid: Race.pickme.rid).sample
		end 
		generate_abilities(60)
		modify_by_race
	end

	def generate_abilities(totpoints)
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

	def modify_by_race
		if (@race.name == "Human")
			@name = HumanName.choosename
		elsif (@race.name == "Dwarf")
			@name = DwarfName.choosename
		end
	end

	def random?(obj)
		obj.name == "Random"
	end

	def finish
		
	end
end
