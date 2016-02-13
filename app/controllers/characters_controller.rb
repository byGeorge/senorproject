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
	end

	def random?(obj)
		obj.name == "Random"
	end

	def finish
		
	end
end
