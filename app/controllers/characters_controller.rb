class CharactersController < ApplicationController

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
		#then sorts the array so that modify_by_class places stats appropriately
		stat.sort!
	end

	#generates skill scores. Method must be run after abl_modify_by_class
	#because it needs ability stats to work
	#skill = skill level + ability mod (ability -10, then divided by two)
	#negative skills are possible. A negative score in, say, deception means
	#that the person is a very bad liar.
	def generate_skills(lvl)
		temp2 = 0 #this is a variable that will always be assigned to a random number
		#calculate skills without ranks
		@acrobatics = (@dex - 10)/2 
		@arcana = (@int - 10)/2 
		@animal_h = (@wis - 10)/2
		@athletics = (@str - 10)/2 
		@deception = (@cha - 10)/2 
		@history = (@int - 10)/2 
		@insight = (@wis - 10)/2 
		@intimidation = (@cha - 10)/2
		@investigation = (@int - 10)/2 
		@medicine = (@wis - 10)/2 
		@nature = (@int - 10)/2
		@perception = (@wis - 10)/2 
		@performance = (@cha - 10)/2 
		@persuasion = (@cha - 10)/2 
		@religion = (@int - 10)/2 
		@sleight_o_hand = (@dex - 10)/2 
		@stealth = (@wis - 10)/2 
		@survival = (@wis - 10)/2 
		#weapons proficiency bonus
		@wpn_prof = 2
		if @c_class.name == "Barbarian"
			#favoured skills are animal handling, athletics,
			#intimidation, nature, perception, and survival
			skills = [0,0,0,0,0,0]
			temp = rand(0..5)
			skills[temp] += 1
			#ranks in skill cannot exceed level
			temp2 = rand(0..5) until temp != temp2
			skills[temp2] += 1
			@animal_h += skills[0]
			@athletics += skills[1]
			@intimidation += skills[2]
			@nature += skills[3]
			@perception += skills[4]
			@survival += skills[5]
			#special skills
			@rage = 2
			@rage_dmg = 2
		elsif @c_class.name == "Bard"
			#one point goes to performance, the other to
			#history, persuasion, sleight of hand, acrobatics, or religion
			@performance += 1
			skills = [0,0,0,0,0]
			skills[rand(0..4)] += 1
			@acrobatics += skills[0]
			@history += skills[1]
			@persuasion += skills[2]
			@religion += skills[3] + (@int - 10)/2 
			@sleight_o_hand += skills[4]
			#special skills
			@spells_known = 4
		elsif @c_class.name == "Cleric"
			#one point goes to medicine, the other to religion
			@medicine += 1
			@religion += 1
		elsif @c_class.name == "Druid"
			#favoured skills are animal handling, medicine,
			#nature, perception, and survival
			skills = [0,0,0,0,0]
			temp = rand(0..4)
			skills[temp] += 1
			#ranks in skill cannot exceed level
			temp2 = rand(0..4) until temp != temp2
			skills[temp2] += 1
			@animal_h += skills[0]
			@medicine += skills[1]
			@nature += skills[2]
			@perception += skills[3]
			@survival += skills[4]
		elsif @c_class.name == "Fighter"
			#favored skills are athletics and perception
			@athletics += 1
			@perception += 1
		elsif @c_class.name == "Monk"
			#favoured skills are acrobatics and athletics 
			@acrobatics += 1
			@athletics += 1
		elsif @c_class.name == "Paladin"
			#favoured skills are intimidation, athletics, and perception
			skills = [0,0,0]
			temp = rand(0..2)
			skills[temp] += 1
			#ranks in skill cannot exceed level
			temp2 = rand(0..2) until temp != temp2
			skills[temp2] += 1
			@athletics += skills[0]
			@intimidation += skills[1]
			@perception += skills[2]
		elsif @c_class.name == "Ranger"
			@nature += 1
			@survival += 1
		elsif @c_class.name == "Rogue"
			#favoured skills are deception, perception, 
			#stealth, and sleight of hand
			skills = [0,0,0,0]
			temp = rand(0..3)
			skills[temp] += 1
			#ranks in skill cannot exceed level
			temp2 = rand(0..3) until temp != temp2
			skills[temp2] += 1
			@deception += skills[0]
			@perception += skills[1]
			@sleight_o_hand += skills[2]
			@stealth = skills[3]
		elsif @c_class.name == "Sorcerer" || "Warlock" || "Wizard"
			#favoured skill is knowledge arcana 
			#other knowledge skills come next
			@arcana += 1
			skills = [0,0,0,0]
			temp = rand(0..3)
			skills[temp] += 1
			#ranks in skill cannot exceed level
			temp2 = rand(0..3) until temp != temp2
			skills[temp2] += 1
			@history += skills[0]
			@medicine += skills[1]
			@nature += skills[2]
			@religion += skills[3]
		end
		for i in 2..@lvl do level_up(i) end
	end # end generate_skills

	def level_spells(lvl)
		if @c_class.name == "Bard"
			if lvl == 2
				@spells[1] += 1
			elsif lvl == 3
				@spells[1] += 1
				@spells[2] += 2
			elsif lvl == 4
				@spells[0] += 1
				@spells[2] += 1
			elsif lvl == 5
				@spells[3] += 2
			elsif lvl == 6
				@spells[3] += 1
			elsif lvl == 7
				@spells[4] += 1
			elsif lvl == 8
				@spells[4] += 1
			elsif lvl == 9
				@spells[4] += 1
				@spells[5] += 1
			elsif lvl == 10
				@spells[0] += 1
				@spells[5] += 1
			elsif lvl == 11
				@spells[6] += 1
			elsif lvl == 12
				
			elsif lvl == 13
				@spells[7] += 1
			elsif lvl == 14

			elsif lvl == 15
				@spells[8] += 1
			elsif lvl == 16

			elsif lvl == 17
				@spells[9] += 1
			elsif lvl == 18
				@spells[5] += 1
			elsif lvl == 19
				@spells[6] += 1
			elsif lvl == 20
				@spells[7] += 1
			end
		end
	end

	def level_up(lvl)
		if @c_class.name == "Barbarian"
			#hit points increase 7 + con mod per level
			@hp += (7 + (@con - 10) / 2)
			#barbarian can rage one more time at levels 3, 6, 12, and 17
			@rage += 1 if lvl == 3 || lvl == 6 || lvl == 12 || lvl == 17
			@rage = "unlimited" if lvl == 20
			#rage gives a bigger damage boost at 9th and 16th levels
			@rage_dmg += 1 if lvl == 9 || lvl == 16
			#better at weapons at 5th, 9th, 13th, and 17th levels
			@wpn_prof += 1 if lvl % 4 == 1
		elsif @c_class.name == "Bard"
			#hit points increase 5 + con mod per level
			@hp += (5 + (@con - 10) / 2)
			@spells_known += 1 if lvl < 10 || lvl == 11 || lvl == 13 || lvl == 15 || lvl == 17
			@spells_known += 2 if lvl == 10 || lvl == 14 || lvl == 18
			#better at weapons at 5th, 9th, 13th, and 17th levels
			@wpn_prof += 1 if lvl % 4 == 1
			level_spells(lvl)
		elsif @c_class.name == "Cleric"

		elsif @c_class.name == "Druid"

		elsif @c_class.name == "Fighter"

		elsif @c_class.name == "Monk"

		elsif @c_class.name == "Paladin"

		elsif @c_class.name == "Ranger"

		elsif @c_class.name == "Rogue"

		elsif @c_class.name == "Sorcerer"

		elsif @c_class.name == "Warlock"

		elsif @c_class.name == "Wizard"

		end
	end


	#initializes and modifies abilities
	def modify_by_class(stat)
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
			#hit points for barbarian = 12 + con mod
			@hp = 12 + (@con-10)/2
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
			#hit points for barbarian = 8 + con mod
			@hp = 8 + (@con-10)/2
			@spells = [2,2,0,0,0,0,0,0,0,0]
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
			@str = stat[2]
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
			@str = stat[0] #wiz don't need no strength
			stat.delete_at(5)
			stat.delete_at(0)
			stat.shuffle!
			@dex = stat[0]
			@con = stat[1]
			@wis = stat[2]
			@cha = stat[3]
		end
		stat #return statement
	end #end modify by class

	#must be called after abl_modify_by_class or it won't work
	#because the stats haven't been initialized
	#changes NPC according to racial abilities
	def modify_by_race
		if (@race.name == "Human")
			@name = HumanName.choosename(@m, @f, @n)
			@str += 1
			@dex += 1
			@con += 1
			@int += 1
			@wis += 1
			@cha += 1
		#for the moment, there is only Mountain Dwarf. Love Mountain Dwarf
		elsif (@race.name == "Dwarf")
			@name = DwarfName.choosename(@m, @f, @n)
			@con += 2
			@str += 2
		#high elf
 		elsif (@race.name == "Elf")
			@name = ElfName.choosename
			@dex += 2
			@int += 1
		end
	end

	#generates all the data for the preview page
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
			@race = Race.all.sample
		end
		if random?(@c_class)
			@c_class = CClass.all.sample
		end
		@lvl = params[:lvl].to_i
		@lvl = rand(1..20) if params[:lvl] == ""
		modify_by_class(generate_abilities(@lvl))
		modify_by_race
		generate_skills(@lvl)
	end

	def random?(obj)
		obj == "Random" || obj == nil
	end
end
