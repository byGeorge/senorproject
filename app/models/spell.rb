class Spell < ActiveRecord::Base
	#picks a random spell at a particular level from the spell list
	def self.pick_spell(level, list, c_class)
		#if the classes have a spell list
		if (c_class == "Bard")
		temp = Spell.all.sample
			#if list hasn't been initialized initialize it. Otherwise, just push it on. 
			#Makes sure it's the right level, class, and isn't duplicated.
			if list == nil
				temp =  Spell.all.sample until (temp.cclass.to_s.include?(c_class) && temp.level == level)
			else
				temp =  Spell.all.sample until (!list.include?(temp) && temp.cclass.to_s.include?(c_class) && temp.level == level)
			end
		list.push(temp)
		#for the classes that know all the spells
		elsif (c_class == "Cleric" || "Druid")
			if (level == 0)
				temp = Spell.all.sample
				if list == nil
					list.push(temp)
				else
					temp =  Spell.all.sample until (!list.include?(temp) && temp.level == 0)
					list.push(temp)
				end
			else
				slist = Spell.all
				slist.each do |spell|
					list.push(spell) if (spell.cclass.to_s.include?(c_class) && spell.level == level)
				end
			end
		end #end if c_class
	end #end pick_spell
end
