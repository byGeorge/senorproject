class RaceController < ApplicationController
	def list
		puts("RaceController output")
		@races = Race.all
	end

	def print_name(object)
		object.name
	end
end
