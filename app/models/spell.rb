class Spell < ActiveRecord::Base
	#picks a random spell at a particular level from the spell list
	def self.pick_spell(level, list, c_class)
		spells = Spell.all
		if list == nil
			spell = spells.sample #until (spell.class == c_class) && (spell.level == level)
		else
			spell = spells.sample until (spell.class == c_class) && (list.not.contains spell) && (spell.level == level)
		end
	end
end
