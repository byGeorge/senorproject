class Spell < ActiveRecord::Base
	#picks a random spell at a particular level from the spell list
	def self.pick_spell(level, list, c_class)
		if list == nil
			spell = Spell.all.sample #until (spell.class == c_class) && (spell.level == level)
		else
			spell = Spell.all.sample until (spell.class == c_class) && (list.not.contains spell) && (spell.level == level)
		end
	end
end
