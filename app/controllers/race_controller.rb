class RaceController < ApplicationController
	def list
		puts(Race.all)
		puts("RaceController output")
		@races = Race.all
	end
end
