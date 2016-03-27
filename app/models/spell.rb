class Spell < ActiveRecord::Base
	#picks a random spell at a particular level from the spell list
	def self.pick_spell(level, list, c_class)
		temp = Spell.all.sample
		if list == nil
			temp =  Spell.all.sample until (temp.cclass.to_s.include?(c_class) && temp.level == level)
		else
			temp =  Spell.all.sample until (!list.include?(temp) && temp.cclass == c_class && temp.level == level)
		end
	list.push(temp)
	end
end
