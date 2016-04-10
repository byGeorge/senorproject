class CharactersController < ApplicationController

	#returns a string that converts inches into feet and inches
	def calculate_height(inches)
		feet = inches / 12
		inch = inches % 12
		if inch == 1
			@height = ("" + feet.to_s + " feet, " + inch.to_s + " inch")
		elsif inch == 0
			@height = ("" + feet.to_s + " feet")
		else
			@height = ("" + feet.to_s + " feet, " + inch.to_s + " inches")
		end
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
		#then sorts the array so that modify_by_class places stats appropriately
		stat.sort!
	end

	#generates special skills for the class, like spells and rages
	def generate_skills(lvl)
		@wpn_prof = 2
		if @c_class.name == "Barbarian"
			#special skills
			@rage = 2
			@rage_dmg = 2
			#description of appearance
		elsif @c_class.name == "Bard"
			#special skills
			@spells_known = 4
			#picks random spells
			@spells_list = Array.new
			2.times { Spell.pick_spell(0, @spells_list, "Bard") } 
			4.times { Spell.pick_spell(1, @spells_list, "Bard") }
		elsif @c_class.name == "Cleric"
			#special skills
			#picks random spells
			@spells_list = Array.new
			3.times { Spell.pick_spell(0, @spells_list, "Cleric") } 
			Spell.pick_spell(1, @spells_list, "Cleric")
		elsif @c_class.name == "Druid"
			#special skills
			#picks random spells
			@spells_list = Array.new
			2.times { Spell.pick_spell(0, @spells_list, "Druid") } 
			Spell.pick_spell(1, @spells_list, "Druid")
		# The following will not be used for some time, but will be added after project is presented
		elsif @c_class.name == "Fighter"
		elsif @c_class.name == "Monk"
		elsif @c_class.name == "Paladin"
		elsif @c_class.name == "Ranger"
		elsif @c_class.name == "Rogue"
		elsif @c_class.name == "Sorcerer" || "Warlock" || "Wizard"
		end #end if class
		#level up to chosen level
		for i in 2..@lvl do level_up(i) end
	end # end generate_skills

	#occasionally, gaining a level allows an increase in ability
	#this will increase abilities randomly, giving priority to class favorites
	def increase_abl
		abl = rand(0..10)
		if @c_class.name == "Barbarian"
			@str += 1 if abl < 3
			@con += 1 if abl >= 3 && abl < 6
			@dex += 1 if abl >= 6 && abl < 8
			@int += 1 if abl == 8
			@wis += 1 if abl == 9
			@cha += 1 if abl == 10
		elsif @c_class.name == "Bard"
			@cha += 1 if abl > 4
			@dex += 1 if abl >= 4 && abl < 7
			@str += 1 if abl == 7
			@con += 1 if abl == 8
			@int += 1 if abl == 9
			@wis += 1 if abl == 10
		elsif @c_class.name == "Cleric"
			@wis += 1 if abl > 4
			@str += 1 if abl >= 4 && abl < 6
			@con += 1 if abl >= 6 && abl < 8
			@dex += 1 if abl == 8
			@int += 1 if abl == 9
			@cha += 1 if abl == 10
		elsif @c_class.name == "Druid"
			@wis += 1 if abl > 4
			@con += 1 if abl >= 4 && abl < 7
			@str += 1 if abl == 7
			@dex += 1 if abl == 8
			@int += 1 if abl == 9
			@cha += 1 if abl == 10
		end #end if class
	end #end increase_abl

	#every character level increases spell ability.
	#this method will choose spells from a list, and increase 
	#spell capacity
	def level_spells(lvl)
		if @c_class.name == "Bard"
			#some increases in level mean the Bard gets to learn more spells
			@spells_known += 1 if lvl < 10 || lvl == 11 || lvl == 13 || lvl == 15 || lvl == 17
			@spells_known += 2 if lvl == 10 || lvl == 14 || lvl == 18
			if lvl == 2
				#add to the number of spells cast per day
				@spells[1] += 1
				#and pick a spell from the list (because @spells_known increased)
				Spell.pick_spell(1, @spells_list, "Bard")
			elsif lvl == 3
				@spells[1] += 1
				@spells[2] += 2
				Spell.pick_spell(2, @spells_list, "Bard")
			elsif lvl == 4
				@spells[0] += 1
				@spells[2] += 1
				Spell.pick_spell(rand(1..2), @spells_list, "Bard")
				Spell.pick_spell(0, @spells_list, "Bard")
			elsif lvl == 5
				@spells[3] += 2
				Spell.pick_spell(3, @spells_list, "Bard")
			elsif lvl == 6
				@spells[3] += 1
				Spell.pick_spell(rand(1..3), @spells_list, "Bard")
			elsif lvl == 7
				@spells[4] += 1
				Spell.pick_spell(4, @spells_list, "Bard")
			elsif lvl == 8
				@spells[4] += 1
				Spell.pick_spell(rand(1..4), @spells_list, "Bard")
			elsif lvl == 9
				@spells[4] += 1
				@spells[5] += 1
				Spell.pick_spell(5, @spells_list, "Bard")
			elsif lvl == 10
				@spells[0] += 1
				@spells[5] += 1
				Spell.pick_spell(0, @spells_list, "Bard")
				Spell.pick_spell(rand(1..5), @spells_list, "Bard")
				Spell.pick_spell(rand(1..5), @spells_list, "Bard")
			elsif lvl == 11
				@spells[6] += 1
				Spell.pick_spell(6, @spells_list, "Bard")
			elsif lvl == 12
				
			elsif lvl == 13
				@spells[7] += 1
				Spell.pick_spell(7, @spells_list, "Bard")
			elsif lvl == 14
				Spell.pick_spell(rand(1..7), @spells_list, "Bard")
				Spell.pick_spell(rand(1..7), @spells_list, "Bard")
			elsif lvl == 15
				@spells[8] += 1
				Spell.pick_spell(8, @spells_list, "Bard")
			elsif lvl == 16

			elsif lvl == 17
				@spells[9] += 1
				Spell.pick_spell(9, @spells_list, "Bard")
			elsif lvl == 18
				@spells[5] += 1
				Spell.pick_spell(rand(1..9), @spells_list, "Bard")
				Spell.pick_spell(rand(1..9), @spells_list, "Bard")
			elsif lvl == 19
				@spells[6] += 1
			elsif lvl == 20
				@spells[7] += 1
			end # end if level
		elsif @c_class.name == "Cleric"
			#clerics know all of the spells available to their class
			if lvl == 2
				#add to the number of spells cast per day
				@spells[1] += 1
			elsif lvl == 3
				@spells[1] += 1
				@spells[2] += 2
				#cleric now has access to lvl 2 spells
				Spell.pick_spell(2, @spells_list, "Cleric")
			elsif lvl == 4
				@spells[0] += 1
				@spells[2] += 1
				Spell.pick_spell(0, @spells_list, "Cleric")
			elsif lvl == 5
				@spells[3] += 2
				Spell.pick_spell(3, @spells_list, "Cleric")
			elsif lvl == 6
				@spells[3] += 1
			elsif lvl == 7
				@spells[4] += 1
				Spell.pick_spell(4, @spells_list, "Cleric")
			elsif lvl == 8
				@spells[4] += 1
			elsif lvl == 9
				@spells[4] += 1
				@spells[5] += 1
				Spell.pick_spell(5, @spells_list, "Cleric")
			elsif lvl == 10
				@spells[0] += 1
				@spells[5] += 1
				Spell.pick_spell(0, @spells_list, "Cleric")
			elsif lvl == 11
				@spells[6] += 1
				Spell.pick_spell(6, @spells_list, "Cleric")
			elsif lvl == 12
				
			elsif lvl == 13
				@spells[7] += 1
				Spell.pick_spell(7, @spells_list, "Cleric")
			elsif lvl == 14

			elsif lvl == 15
				@spells[8] += 1
				Spell.pick_spell(8, @spells_list, "Cleric")
			elsif lvl == 16

			elsif lvl == 17
				@spells[9] += 1
				Spell.pick_spell(9, @spells_list, "Cleric")
			elsif lvl == 18
				@spells[5] += 1
			elsif lvl == 19
				@spells[6] += 1
			elsif lvl == 20
				@spells[7] += 1
			end # end if level
		elsif @c_class.name == "Druid"
			#druids know all of the spells available to their class
			if lvl == 2
				#add to the number of spells cast per day
				@spells[1] += 1
			elsif lvl == 3
				@spells[1] += 1
				@spells[2] += 2
				#Druid now has access to lvl 2 spells
				Spell.pick_spell(2, @spells_list, "Druid")
			elsif lvl == 4
				@spells[0] += 1
				@spells[2] += 1
				Spell.pick_spell(0, @spells_list, "Druid")
			elsif lvl == 5
				@spells[3] += 2
				Spell.pick_spell(3, @spells_list, "Druid")
			elsif lvl == 6
				@spells[3] += 1
			elsif lvl == 7
				@spells[4] += 1
				Spell.pick_spell(4, @spells_list, "Druid")
			elsif lvl == 8
				@spells[4] += 1
			elsif lvl == 9
				@spells[4] += 1
				@spells[5] += 1
				Spell.pick_spell(5, @spells_list, "Druid")
			elsif lvl == 10
				@spells[0] += 1
				@spells[5] += 1
				Spell.pick_spell(0, @spells_list, "Druid")
			elsif lvl == 11
				@spells[6] += 1
				Spell.pick_spell(6, @spells_list, "Druid")
			elsif lvl == 12
				
			elsif lvl == 13
				@spells[7] += 1
				Spell.pick_spell(7, @spells_list, "Druid")
			elsif lvl == 14

			elsif lvl == 15
				@spells[8] += 1
				Spell.pick_spell(8, @spells_list, "Druid")
			elsif lvl == 16

			elsif lvl == 17
				@spells[9] += 1
				Spell.pick_spell(9, @spells_list, "Druid")
			elsif lvl == 18
				@spells[5] += 1
			elsif lvl == 19
				@spells[6] += 1
			elsif lvl == 20
				@spells[7] += 1
			end # end if level
		end # end if class
	end #end level spells

	#levels up character
	def level_up(lvl)
		increase_abl if lvl % 4 == 1
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
			#better at weapons at 5th, 9th, 13th, and 17th levels
			@wpn_prof += 1 if lvl % 4 == 1
			level_spells(lvl)
		elsif @c_class.name == "Cleric"
			#hit points increase 8 + con mod per level
			@hp += (8 + (@con - 10) / 2)
			#better at weapons at 5th, 9th, 13th, and 17th levels
			@wpn_prof += 1 if lvl % 4 == 1
			level_spells(lvl)
		elsif @c_class.name == "Druid"
			#hit points increase 8 + con mod per level
			@hp += (8 + (@con - 10) / 2)
			level_spells(lvl)
			#better at weapons at 5th, 9th, 13th, and 17th levels
			@wpn_prof += 1 if lvl % 4 == 1
		#code for these will be added after presentation
		elsif @c_class.name == "Fighter"

		elsif @c_class.name == "Monk"

		elsif @c_class.name == "Paladin"

		elsif @c_class.name == "Ranger"

		elsif @c_class.name == "Rogue"

		elsif @c_class.name == "Sorcerer"

		elsif @c_class.name == "Warlock"

		elsif @c_class.name == "Wizard"

		end #end if class
	end #end level up


	#initializes and modifies abilities and skills
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
			#hit points for bard = 8 + con mod
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
			#hit points for cleric = 8 + con mod
			@hp = 8 + (@con-10)/2
			@spells = [3,2,0,0,0,0,0,0,0,0]
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
			#hit points for Druid = 8 + con mod
			@hp = 8 + (@con-10)/2
			@spells = [2,2,0,0,0,0,0,0,0,0]
		# remaining code for this will be added after presentation
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
		end #end if class
		stat #return statement
	end #end modify by class

	#must be called after abl_modify_by_class or it won't work
	#because the stats haven't been initialized
	#changes NPC according to racial abilities
	def modify_by_race
		if (@race.name == "Human")
			@name = HumanName.choosename(@m, @f, @n)
			#add racial bonuses
			@str += 1
			@dex += 1
			@con += 1
			@int += 1
			@wis += 1
			@cha += 1
			@age = rand(16..100)
			calculate_height(rand(60..76))
			@weight = rand(125..250)
		#for the moment, there is only Mountain Dwarf. Mountain Dwarf is king.
		elsif (@race.name == "Dwarf")
			@name = DwarfName.choosename(@m, @f, @n)
			@con += 2
			@str += 2
			#dwarves reach adulthood at 50 and live for about 350 years
			@age = rand(50..350)
			calculate_height(rand(48..60))
			#dwarves are 4-5 feet tall and about 150 pounds
			@weight = 125 + rand(50)
		#high elf
 		elsif (@race.name == "Elf")
			@name = ElfName.choosename
			@dex += 2
			@int += 1
			@age = rand(100..750)
			calculate_height(rand(52..62))
			@weight = rand(100..145)			
		end #end if race
	end #end modify_by_race

	#generates all the data for the preview page
	def preview
		#getting params from form entries
		race_id_temp = params[:race][:race_id].to_i
		c_class_id_temp = params[:c_class][:class_id].to_i
		#m f and n only affect names and are not printed on the sheet
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

		# modify stats by class and race
		modify_by_class(generate_abilities(@lvl))
		modify_by_race
		generate_skills(@lvl)
		@appearance = Appearance.generate
		#saving relevant data to string
		char_temp = @name + "|" + @lvl.to_s + "|" + @race.id.to_s + "|" + 
			@str.to_s + "|" + @dex.to_s + "|" + @con.to_s + "|" + 
			@int.to_s + "|" +@wis.to_s + "|" + @cha.to_s + "|" + 
			@c_class.id.to_s + "|" + @hp.to_s + "|" + @appearance + "|" +
			@height.to_s + " tall, " + @weight.to_s + " pounds, " + @age.to_s + " years old|"
		if @spells_list
			char_temp = char_temp + @spells_list.select { |spell| spell.id }.map(&:id).join(',')
		end
		#putting string into cooookie
		session[:character] = char_temp
	end #end preview

	#Determines if object is random
	def random?(obj)
		obj == "Random" || obj == nil
	end

	#saves data to character
	def create
		#retrieves data from cookie (om nom nom)
		char_temp = session[:character].split('|').reverse!
		#this is the saving part of saving the data to the character
		@npc = Character.create do |c|
			c.userid = session[:user]
			c.name = char_temp.pop
			c.level = char_temp.pop
			c.race = char_temp.pop
			c.strength = char_temp.pop
			c.dexterity = char_temp.pop
			c.constitution = char_temp.pop
			c.intelligence = char_temp.pop
			c.wisdom = char_temp.pop
			c.charisma = char_temp.pop
			c.cclass = char_temp.pop
			c.hit_points = char_temp.pop
			c.quirks = char_temp.pop
			c.height_weight_age = char_temp.pop
			c.spells_list = char_temp.pop unless c.cclass == 1 #unless it's a barbarian
		end
		#we don't need to store all that crap in the cookie anymore
		session[:character] = nil
	end

	#I don't think I actually ever use this, but it throws an exception if this isn't present
	def index
		current_npc = Character.find_by_id(session[:character])
	end

	#I don't think I actually ever use this, but it throws an exception if this isn't present
	def update
		session[:character] = @character.id
	end

	#will show data for selected npc
	def view
		#save the form result into the cookie as character data
		session[:character] = params[:npc]

		#finds character in the database
		@npc = Character.find_by_id(session[:character])

		#if there is a selected character, parse the relevant data to show on form
		if params[:npc] != nil
			#calculate proficiency bonus
			@wpn_prof = 2 + (@npc.level - 1)/4

			#special class things like rage/spells/etc
			if @npc.cclass == 1 #barbarian
				if @npc.level <= 2
					@rage = 2
				elsif @npc.level > 2 && @npc.level <= 5
					@rage = 3
				elsif @npc.level > 5 && @npc.level <= 11
					@rage = 4
				elsif @npc.level > 11 && @npc.level <= 16
					@rage = 5
				elsif @npc.level > 16 && @npc.level <= 19
					@rage = 6
				else
					@rage = "unlimited"
				end

				if @npc.level <= 8
					@rage_dmg = 2
				elsif @npc.level > 8 && @npc.level <= 15
					@rage_dmg = 3
				else
					@rage_dmg = 4
				end
			elsif @npc.cclass > 1 && @npc.cclass <= 4 #if this is a class with spells
				slist = @npc.spells_list.split(',')
				@spells_list = Array.new
				slist.each do |spell| 
					add = Spell.find_by_id(spell)
					@spells_list.push(add)
				end
				if @npc.cclass == 2 #bard
					@spells_known = 4
					@spells_known += 1 if @npc.level < 10 || @npc.level == 11 || @npc.level == 13 || @npc.level == 15 || @npc.level == 17
					@spells_known += 2 if @npc.level == 10 || @npc.level == 14 || @npc.level == 18
				end

				@spells = [0,0,0, 0,0,0, 0,0,0, 0]
				if @npc.level == 1
					@spells[0] = 2
					@spells[1] = 2
				elsif @npc.level == 2
					@spells[0] = 2
					@spells[1] = 3
				elsif @npc.level == 3
					@spells[0] = 2
					@spells[1] = 4
					@spells[2] = 2
				elsif @npc.level == 4
					@spells[0] = 3
					@spells[1] = 4
					@spells[2] = 3
				elsif @npc.level == 5
					@spells[0] = 3
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 2
				elsif @npc.level == 6
					@spells[0] = 3
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3
				elsif @npc.level == 7
					@spells[0] = 3
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 1
				elsif @npc.level == 8
					@spells[0] = 3
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 2
				elsif @npc.level == 9
					@spells[0] = 3
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 3
					@spells[5] = 1
				elsif @npc.level == 10
					@spells[0] = 4
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 3
					@spells[5] = 2
				elsif @npc.level == 11
					@spells[0] = 4
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 3
					@spells[5] = 2					
					@spells[6] = 1
				elsif @npc.level == 12
					@spells[0] = 4
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 3
					@spells[5] = 2					
					@spells[6] = 1					
				elsif @npc.level == 13
					@spells[0] = 4
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 3
					@spells[5] = 2					
					@spells[6] = 1					
					@spells[7] = 1
				elsif @npc.level == 14
					@spells[0] = 4
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 3
					@spells[5] = 2					
					@spells[6] = 1					
					@spells[7] = 1
				elsif @npc.level == 15
					@spells[0] = 4
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 3
					@spells[5] = 2					
					@spells[6] = 1					
					@spells[7] = 1					
					@spells[8] = 1
				elsif @npc.level == 16
					@spells[0] = 4
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 3
					@spells[5] = 2					
					@spells[6] = 1					
					@spells[7] = 1					
					@spells[8] = 1
				elsif @npc.level == 17
					@spells[0] = 4
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 3
					@spells[5] = 2					
					@spells[6] = 1					
					@spells[7] = 1					
					@spells[8] = 1
					@spells[9] = 1
				elsif @npc.level == 18
					@spells[0] = 4
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 3
					@spells[5] = 3					
					@spells[6] = 1					
					@spells[7] = 1					
					@spells[8] = 1
					@spells[9] = 1
				elsif @npc.level == 19
					@spells[0] = 4
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 3
					@spells[5] = 3					
					@spells[6] = 2
					@spells[7] = 1					
					@spells[8] = 1
					@spells[9] = 1
				elsif @npc.level == 20
					@spells[0] = 4
					@spells[1] = 4
					@spells[2] = 3
					@spells[3] = 3					
					@spells[4] = 3
					@spells[5] = 3					
					@spells[6] = 2
					@spells[7] = 2
					@spells[8] = 1
					@spells[9] = 1
				end # end if level

				#clerics are special snowflakes, and get one more cantrip than everyone else
				if @npc.cclass == 3 # if cleric
					@spells[0] += 1
				end
			end # end if caster class
		end #end if npc
	end #end view
end #end characters_controller
