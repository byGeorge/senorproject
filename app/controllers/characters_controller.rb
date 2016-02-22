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
		@m = params[:m]
		@f = params[:f]
		@n = params[:n]
		@race = Race.find_by_id(race_id_temp)
		if random?(@race)
			@race = Race.where.not(id: Race.pickme.id).sample
		end
		@lvl = 1 
		modify_by_class(generate_abilities(@lvl))
		modify_by_race
	end

	#generates ability scores based on level, and returns a range of stats
	#that will later be modified by class (with modify_by_class(stats[]))
	def generate_abilities(lvl)
		d = [0,0,0,0,0]
		stat = [0,0,0,0,0,0]
		for i in (0..5) 
			d[0] = rand(1..6)
			d[1] = rand(1..6)
			d[2] = rand(1..6)
			d[3] = rand(1..6)
			#roll 4d6 and keep the three highest
			#compare the first two dice and add the highest to the total
			#lowest die is saved to compare later
			if d[0] > d[1]
				stat[i] = d[0]
				d[4] = d[1]
			else
				stat[i] = d[1]
				d[4] = d[0]
			end
			#compare the next two dice and add the highest to the total
			#lowest die is saved to compare later
			if d[2] > d[3] 
				stat[i] += d[2]
				d[5] = d[3]
			else
				stat[i] += d[3]
				d[5] = d[2]
			end
			#compare last two dice and add the highest to the total
			#last die is forgotten and dies a lonely death
			if d[4] > d[5]
				stat[i] += d[4]
			else
				stat[i] += d[5]
			end
		end
		stat
	end

	#must be called after modify_by_class or it won't work
	#changes NPC according to racial abilities
	def modify_by_race
		if (@race.name == "Human")
			@name = HumanName.choosename(@m, @f, @n)
		elsif (@race.name == "Dwarf")
			@name = DwarfName.choosename(@m, @f, @n)
			@con += 2
 		elsif (@race.name == "Elf")
			@name = ElfName.choosename
			@dex += 2
		end
	end

	#initializes and modifies abilitis
	def modify_by_class(stat)
		@str = stat[0]
		@dex = stat[1]
		@con = stat[2]
		@int = stat[3]
		@wis = stat[4]
		@cha = stat[5]
	end

	def random?(obj)
		obj.name == "Random"
	end

	def finish
		
	end
end
