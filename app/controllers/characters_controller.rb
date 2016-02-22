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
		#getting params from form entries
		race_id_temp = params[:race][:race_id].to_i
		c_class_id_temp = params[:c_class][:class_id].to_i
		@m = params[:m]
		@f = params[:f]
		@n = params[:n]
		#turning the form object into a successful database query
		@race = Race.find_by_id(race_id_temp)
		@c_class = CClass.find_by_id(c_class_id_temp)
		#picking a random race/class/etc if the user selected Random
		if random?(@race)
			@race = Race.where.not(id: Race.pickme.id).sample
		end
		if random?(@c_class)
			@c_class = CClass.where.not(id: CClass.pickme.id).sample
		end
		@lvl = 1 
		abl_modify_by_class(generate_abilities(@lvl))
		modify_by_race
	end

	#generates ability scores based on level, and returns a range of stats
	#that will later be modified by class (with modify_by_class(stats[]))
	#stats arranged from lowest to highest number
	def generate_abilities(lvl)
		d = [0,0,0,0]
		stat = [0,0,0,0,0,0]
		for i in (0..5) 
			#rolls 4d6
			d[0] = rand(1..6)
			d[1] = rand(1..6)
			d[2] = rand(1..6)
			d[3] = rand(1..6)
			#sorts them from lowest to highest
			d.sort!
			#takes the highest three
			stat[i] = d[1] + d[2] + d[3]
		end
		stat.sort!
	end

	#must be called after modify_by_class or it won't work
	#because the stats haven't been initialized
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

	#initializes and modifies abilities
	def abl_modify_by_class(stat)
		if @c_class.name == "Barbarian"
			@str = stat[5]
			@con = stat[4]
			stat.delete_at(5)
			stat.delete_at(4)
			stat.shuffle!
			@dex = stat[0]
			@int = stat[1]
			@wis = stat[2]
			@cha = stat[3]
		elsif @c_class.name == "Bard"
			@cha = stat[5]
			@dex = stat[4]
			stat.delete_at(5)
			stat.delete_at(4)
			stat.shuffle!
			@str = stat[0]
			@con = stat[1]
			@int = stat[2]
			@wis = stat[3]
		elsif @c_class.name == "Cleric"
			@wis = stat[5]
			@con = stat[4]
			@str = stat[3]
			stat.delete_at(5)
			stat.delete_at(4)
			stat.delete_at(3)
			stat.shuffle!
			@dex = stat[0]
			@int = stat[1]
			@cha = stat[2]
		elsif @c_class.name == "Druid"
			@wis = stat[5]
			@con = stat[4]
			stat.delete_at(5)
			stat.delete_at(4)
			stat.shuffle!
			@dex = stat[0]
			@int = stat[1]
			@con = stat[2]
			@cha = stat[3]
		elsif @c_class.name == "Fighter"
			@str = stat[5]
			@con = stat[4]
			@dex = stat[3]
			stat.delete_at(5)
			stat.delete_at(4)
			stat.delete_at(3)
			stat.shuffle!
			@cha = stat[0]
			@int = stat[1]
			@wis = stat[2]
		elsif @c_class.name == "Monk"
			@dex = stat[5]
			@wis = stat[4]
			stat.delete_at(5)
			stat.delete_at(4)
			stat.shuffle!
			@str = stat[0]
			@con = stat[1]
			@int = stat[2]
			@cha = stat[3]
		elsif @c_class.name == "Paladin"
			@str = stat[5]
			@cha = stat[4]
			@con = stat[3]
			stat.delete_at(5)
			stat.delete_at(4)
			stat.delete_at(3)
			stat.shuffle!
			@dex = stat[0]
			@int = stat[1]
			@wis = stat[2]
		elsif @c_class.name == "Ranger"
			@dex = stat[5]
			@wis = stat[4]
			stat.delete_at(5)
			stat.delete_at(4)
			stat.shuffle!
			@str = stat[0]
			@con = stat[1]
			@int = stat[2]
			@cha = stat[3]
		elsif @c_class.name == "Rogue"
			@dex = stat[5]
			@int = stat[4]
			@cha = stat[3]
			stat.delete_at(5)
			stat.delete_at(4)
			stat.delete_at(3)
			stat.shuffle!
			@str = stat[0]
			@con = stat[1]
			@wis = stat[2]
		elsif @c_class.name == "Sorcerer"
			@cha = stat[5]
			@con = stat[4]
			stat.delete_at(5)
			stat.delete_at(4)
			stat.shuffle!
			@dex = stat[0]
			@int = stat[1]
			@wis = stat[2]
			@str = stat[3]
		elsif @c_class.name == "Warlock"
			@cha = stat[5]
			@con = stat[4]
			stat.delete_at(5)
			stat.delete_at(4)
			stat.shuffle!
			@dex = stat[0]
			@int = stat[1]
			@wis = stat[2]
			@str = stat[3]
		elsif @c_class.name == "Wizard"
			@int = stat[5]
			@str = stat[0]
			stat.delete_at(5)
			stat.delete_at(0)
			stat.shuffle!
			@dex = stat[0]
			@con = stat[1]
			@wis = stat[2]
			@cha = stat[3]
		end
		stat
	end

	def random?(obj)
		obj.name == "Random"
	end

	def finish
		
	end
end
