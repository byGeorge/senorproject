class SessionController < ApplicationController
	def create
		session[:user] = @user.id
	end

	def index
		current_user = User.find_by_id(session[:user])
	end

	def update
		session[:user] = @user.id
	end
end
