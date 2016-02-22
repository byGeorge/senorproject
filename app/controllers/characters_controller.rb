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
		c_class_id_temp = params[:c_class][:class_id].to_i
		@m = params[:m]
		@f = params[:f]
		@n = params[:n]
		@race = Race.find_by_id(race_id_temp)
		if random?(@race)
			@race = Race.where.not(id: Race.pickme.id).sample
		end
		@c_class = CClass.find_by_id(c_class_id_temp)
		if random?(@c_class)
			@race = CClass.where.not(id: CClass.pickme.id).sample
		end
		@lvl = 1 
		modify_by_class(generate_abilities(@lvl))
		modify_by_race
	end

	#generates ability scores based on level, and returns a range of stats
	#that will later be modified by class (with modify_by_class(stats[]))
	#stats arranged from lowest to highest number
	def generate_abilities(lvl)
		d = [0,0,0,0]
		stat = [0,0,0,0,0,0]
		for i in (0..5) 
			d[0] = rand(1..6)
			d[1] = rand(1..6)
			d[2] = rand(1..6)
			d[3] = rand(1..6)
			d.sort!
			stat[i] = d[1] + d[2] + d[3]
		end
		stat.sort!
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
