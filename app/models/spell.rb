class Spell < ActiveRecord::Base
	#picks a random spell at a particular level from the spell list
	def self.pick_spell(level, list, c_class)
		if list == nil
			fu = Spell.all
			binding.pry
			spell = Spell.all.sample.where(spell.class == c_class && spell.level == level)
		else
			spell = Spell.all.sample.where(spell.class == c_class && list.not.contains(spell) && spell.level == level)
		end
	end
end
