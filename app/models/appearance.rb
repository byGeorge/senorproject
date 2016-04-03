class Appearance < ActiveRecord::Base
	#picks 1-3 blurbs from the database to make the character more interesting
	def self.generate
		blurb = Array.new
		blurb.push(Appearance.all.sample)
		i = 0
		while i <= rand(0..2) do 
			add = Appearance.all.sample 
			#makes sure two blurbs from the same category aren't added to the appearance paragraph
			if !blurb.include?(add) 
				good = 1
				blurb.each do |meow| 
					add.category.eql?(meow.category) ? good = 0 : ""
				end
				if good == 1
					blurb.push(add)
					i += 1
				end
			end 
		end
		toReturn = ""
		blurb.each do |blarb| 
			toReturn = toReturn + " " + blarb.description
		end
		toReturn
	end
end
