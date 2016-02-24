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
			@race = Race.all.sample
		end
		if random?(@c_class)
			@c_class = CClass.all.sample
		end
		@lvl = 1 
		abl_modify_by_class(generate_abilities(@lvl))
		modify_by_race
		generate_skills(@lvl)
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

	#generates skill scores. Method must be run after abl_modify_by_class
	#because it needs ability stats to work
	#skill = skill level + ability mod (ability -10, then divided by two)
	#negative skills are possible. A negative score in, say, deception means
	#that the person is a very bad liar.
	def generate_skills(lvl)
		if @c_class.name == "Barbarian"
			#favoured skills are animal handling, athletics,
			#intimidation, nature, perception, and survival
			skills = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			skills[rand(0..5)] += 1
			#ranks in skill cannot exceed level
			temp = 0 #frustrating that it won't set a random unless initialized
			temp = rand(0..5) until skills[temp] == 0
			skills[temp] += 1
			
			#calculate skills; first slots are given to favoured skills
			@acrobatics = skills[6] + (@dex - 10)/2 
			@arcana = skills[7] + (@int - 10)/2 
			@animal_h = skills[0] + (@wis - 10)/2
			@athletics = skills[1] + (@str - 10)/2 
			@deception = skills[8] + (@cha - 10)/2 
			@history = skills[9] + (@int - 10)/2 
			@insight = skills[10] + (@wis - 10)/2 
			@intimidation = skills[2] + (@cha - 10)/2
			@investigation = skills[11] + (@int - 10)/2 
			@medicine = skills[12] + (@wis - 10)/2 
			@nature = skills[3] + (@int - 10)/2
			@perception = skills[4] + (@wis - 10)/2 
			@performance = skills[14] + (@cha - 10)/2 
			@persuasion = skills[15] + (@cha - 10)/2 
			@religion = skills[16] + (@int - 10)/2 
			@sleight_o_hand = skills[17] + (@dex - 10)/2 
			@stealth = skills[13] + (@wis - 10)/2 
			@survival = skills[5] + (@wis - 10)/2 
		elsif @c_class.name == "Bard"
			#one point goes to performance, the other to
			#history, persuasion, sleight of hand, acrobatics, or religion
			skills = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			skills[rand(1..5)] += 1
			
			#calculate skills; first slots are given to favoured skills
			@acrobatics = skills[5] + (@dex - 10)/2 
			@arcana = skills[7] + (@int - 10)/2 
			@animal_h = skills[8] + (@wis - 10)/2
			@athletics = skills[9] + (@str - 10)/2 
			@deception = skills[10] + (@cha - 10)/2 
			@history = skills[5] + (@int - 10)/2 
			@insight = skills[11] + (@wis - 10)/2 
			@intimidation = skills[12] + (@cha - 10)/2
			@investigation = skills[13] + (@int - 10)/2 
			@medicine = skills[14] + (@wis - 10)/2 
			@nature = skills[15] + (@int - 10)/2
			@perception = skills[16] + (@wis - 10)/2 
			@performance = skills[0] + (@cha - 10)/2 
			@persuasion = skills[4] + (@cha - 10)/2 
			@religion = skills[3] + (@int - 10)/2 
			@sleight_o_hand = skills[2] + (@dex - 10)/2 
			@stealth = skills[6] + (@wis - 10)/2 
			@survival = skills[17] + (@wis - 10)/2
		elsif @c_class.name == "Cleric"
			#one point goes to medicine, the other to religion
			#history, persuasion, sleight of hand, acrobatics, or religion
			skills = [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			
			#calculate skills; first slots are given to favoured skills
			@acrobatics = skills[2] + (@dex - 10)/2 
			@arcana = skills[3] + (@int - 10)/2 
			@animal_h = skills[4] + (@wis - 10)/2
			@athletics = skills[5] + (@str - 10)/2 
			@deception = skills[6] + (@cha - 10)/2 
			@history = skills[7] + (@int - 10)/2 
			@insight = skills[8] + (@wis - 10)/2 
			@intimidation = skills[9] + (@cha - 10)/2
			@investigation = skills[10] + (@int - 10)/2 
			@medicine = skills[0] + (@wis - 10)/2 
			@nature = skills[11] + (@int - 10)/2
			@perception = skills[12] + (@wis - 10)/2 
			@performance = skills[13] + (@cha - 10)/2 
			@persuasion = skills[14] + (@cha - 10)/2 
			@religion = skills[1] + (@int - 10)/2 
			@sleight_o_hand = skills[15] + (@dex - 10)/2 
			@stealth = skills[16] + (@wis - 10)/2 
			@survival = skills[17] + (@wis - 10)/2
		elsif @c_class.name == "Druid"
			#favoured skills are animal handling, medicine,
			#nature, perception, and survival
			skills = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			skills[rand(0..4)] += 1
			#ranks in skill cannot exceed level
			temp = 0 #frustrating that it won't set a random unless initialized
			temp = rand(0..4) until skills[temp] == 0
			skills[temp] += 1
			
			#calculate skills; first slots are given to favoured skills
			@acrobatics = skills[5] + (@dex - 10)/2 
			@arcana = skills[6] + (@int - 10)/2 
			@animal_h = skills[0] + (@wis - 10)/2
			@athletics = skills[7] + (@str - 10)/2 
			@deception = skills[8] + (@cha - 10)/2 
			@history = skills[9] + (@int - 10)/2 
			@insight = skills[10] + (@wis - 10)/2 
			@intimidation = skills[11] + (@cha - 10)/2
			@investigation = skills[12] + (@int - 10)/2 
			@medicine = skills[1] + (@wis - 10)/2 
			@nature = skills[2] + (@int - 10)/2
			@perception = skills[3] + (@wis - 10)/2 
			@performance = skills[13] + (@cha - 10)/2 
			@persuasion = skills[14] + (@cha - 10)/2 
			@religion = skills[15] + (@int - 10)/2 
			@sleight_o_hand = skills[16] + (@dex - 10)/2 
			@stealth = skills[17] + (@wis - 10)/2 
			@survival = skills[4] + (@wis - 10)/2
		elsif @c_class.name == "Fighter"
			#favored skill is athletics. 
			skills = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			skills[rand(1..17)] += 1
			
			#calculate skills; first slots are given to favoured skills
			@acrobatics = skills[1] + (@dex - 10)/2 
			@arcana = skills[2] + (@int - 10)/2 
			@animal_h = skills[3] + (@wis - 10)/2
			@athletics = skills[0] + (@str - 10)/2 
			@deception = skills[4] + (@cha - 10)/2 
			@history = skills[5] + (@int - 10)/2 
			@insight = skills[6] + (@wis - 10)/2 
			@intimidation = skills[7] + (@cha - 10)/2
			@investigation = skills[8] + (@int - 10)/2 
			@medicine = skills[9] + (@wis - 10)/2 
			@nature = skills[10] + (@int - 10)/2
			@perception = skills[11] + (@wis - 10)/2 
			@performance = skills[12] + (@cha - 10)/2 
			@persuasion = skills[13] + (@cha - 10)/2 
			@religion = skills[14] + (@int - 10)/2 
			@sleight_o_hand = skills[15] + (@dex - 10)/2 
			@stealth = skills[16] + (@wis - 10)/2 
			@survival = skills[17] + (@wis - 10)/2
		elsif @c_class.name == "Monk"
			#favoured skills are acrobatics and athletics 
			skills = [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			
			#calculate skills; first slots are given to favoured skills
			@acrobatics = skills[0] + (@dex - 10)/2 
			@arcana = skills[2] + (@int - 10)/2 
			@animal_h = skills[3] + (@wis - 10)/2
			@athletics = skills[1] + (@str - 10)/2 
			@deception = skills[4] + (@cha - 10)/2 
			@history = skills[5] + (@int - 10)/2 
			@insight = skills[6] + (@wis - 10)/2 
			@intimidation = skills[7] + (@cha - 10)/2
			@investigation = skills[8] + (@int - 10)/2 
			@medicine = skills[9] + (@wis - 10)/2 
			@nature = skills[10] + (@int - 10)/2
			@perception = skills[11] + (@wis - 10)/2 
			@performance = skills[12] + (@cha - 10)/2 
			@persuasion = skills[13] + (@cha - 10)/2 
			@religion = skills[14] + (@int - 10)/2 
			@sleight_o_hand = skills[15] + (@dex - 10)/2 
			@stealth = skills[16] + (@wis - 10)/2 
			@survival = skills[17] + (@wis - 10)/2
		elsif @c_class.name == "Paladin"
			#favoured skills are intimidation and athletics
			skills = [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			
			#calculate skills; first slots are given to favoured skills
			@acrobatics = skills[2] + (@dex - 10)/2 
			@arcana = skills[3] + (@int - 10)/2 
			@animal_h = skills[4] + (@wis - 10)/2
			@athletics = skills[1] + (@str - 10)/2 
			@deception = skills[5] + (@cha - 10)/2 
			@history = skills[6] + (@int - 10)/2 
			@insight = skills[7] + (@wis - 10)/2 
			@intimidation = skills[0] + (@cha - 10)/2
			@investigation = skills[8] + (@int - 10)/2 
			@medicine = skills[9] + (@wis - 10)/2 
			@nature = skills[10] + (@int - 10)/2
			@perception = skills[11] + (@wis - 10)/2 
			@performance = skills[12] + (@cha - 10)/2 
			@persuasion = skills[13] + (@cha - 10)/2 
			@religion = skills[14] + (@int - 10)/2 
			@sleight_o_hand = skills[15] + (@dex - 10)/2 
			@stealth = skills[16] + (@wis - 10)/2 
			@survival = skills[17] + (@wis - 10)/2
		elsif @c_class.name == "Ranger"
			#favoured skills are nature ad survival
			skills = [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			
			#calculate skills; first slots are given to favoured skills
			@acrobatics = skills[2] + (@dex - 10)/2 
			@arcana = skills[3] + (@int - 10)/2 
			@animal_h = skills[4] + (@wis - 10)/2
			@athletics = skills[5] + (@str - 10)/2 
			@deception = skills[6] + (@cha - 10)/2 
			@history = skills[7] + (@int - 10)/2 
			@insight = skills[8] + (@wis - 10)/2 
			@intimidation = skills[9] + (@cha - 10)/2
			@investigation = skills[10] + (@int - 10)/2 
			@medicine = skills[11] + (@wis - 10)/2 
			@nature = skills[0] + (@int - 10)/2
			@perception = skills[12] + (@wis - 10)/2 
			@performance = skills[13] + (@cha - 10)/2 
			@persuasion = skills[14] + (@cha - 10)/2 
			@religion = skills[15] + (@int - 10)/2 
			@sleight_o_hand = skills[16] + (@dex - 10)/2 
			@stealth = skills[17] + (@wis - 10)/2 
			@survival = skills[1] + (@wis - 10)/2
		elsif @c_class.name == "Rogue"
			#favoured skills are deception, perception, 
			#stealth, and sleight of hand
			skills = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			skills[rand(0..3)] += 1
			#ranks in skill cannot exceed level
			temp = 0 #frustrating that it won't set a random unless initialized
			temp = rand(0..3) until skills[temp] == 0
			skills[temp] += 1
			
			#calculate skills; first slots are given to favoured skills
			@acrobatics = skills[4] + (@dex - 10)/2 
			@arcana = skills[5] + (@int - 10)/2 
			@animal_h = skills[6] + (@wis - 10)/2
			@athletics = skills[7] + (@str - 10)/2 
			@deception = skills[0] + (@cha - 10)/2 
			@history = skills[8] + (@int - 10)/2 
			@insight = skills[9] + (@wis - 10)/2 
			@intimidation = skills[10] + (@cha - 10)/2
			@investigation = skills[11] + (@int - 10)/2 
			@medicine = skills[12] + (@wis - 10)/2 
			@nature = skills[13] + (@int - 10)/2
			@perception = skills[1] + (@wis - 10)/2 
			@performance = skills[14] + (@cha - 10)/2 
			@persuasion = skills[15] + (@cha - 10)/2 
			@religion = skills[16] + (@int - 10)/2 
			@sleight_o_hand = skills[2] + (@dex - 10)/2 
			@stealth = skills[3] + (@wis - 10)/2 
			@survival = skills[17] + (@wis - 10)/2
		elsif @c_class.name == "Sorcerer" || "Warlock" || "Wizard"
			#favoured skill is knowledge arcana 
			#other knowledge skills come next
			skills = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
			skills[rand(1..4)] += 1
			
			#calculate skills; first slots are given to favoured skills
			@acrobatics = skills[5] + (@dex - 10)/2 
			@arcana = skills[0] + (@int - 10)/2 
			@animal_h = skills[6] + (@wis - 10)/2
			@athletics = skills[7] + (@str - 10)/2 
			@deception = skills[8] + (@cha - 10)/2 
			@history = skills[4] + (@int - 10)/2 
			@insight = skills[9] + (@wis - 10)/2 
			@intimidation = skills[10] + (@cha - 10)/2
			@investigation = skills[11] + (@int - 10)/2 
			@medicine = skills[3] + (@wis - 10)/2 
			@nature = skills[2] + (@int - 10)/2
			@perception = skills[12] + (@wis - 10)/2 
			@performance = skills[13] + (@cha - 10)/2 
			@persuasion = skills[14] + (@cha - 10)/2 
			@religion = skills[1] + (@int - 10)/2 
			@sleight_o_hand = skills[15] + (@dex - 10)/2 
			@stealth = skills[16] + (@wis - 10)/2 
			@survival = skills[17] + (@wis - 10)/2

		end
	end

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
		obj == "Random" || obj == nil
	end

	def finish
		
	end
end
