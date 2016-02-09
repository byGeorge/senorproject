class PagesController < ApplicationController
	@race

	def login
	end

	def get_race
		@race
	end

	def print_race
		puts("print_race")
	end

	def post
		@race = @race
	end
end
