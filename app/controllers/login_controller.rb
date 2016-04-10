class LoginController < ApplicationController

	#logs in a user if the username can be found
	def logged
		@login_token = 0
		usr = params[:username]
		pwd = params[:password]
		@user = User.find_by_name(usr)
		@login_token = 1 unless @user == nil || !pwd.eql?(@user.password)
	end

	def new
		#reset the messages and set login token to 0
		@login_token = 0
		@messageu = nil
		@messagep = nil
		user = params[:usr]
		pwd1 = params[:pwd]
		pwd2 = params[:pw2]

		#make sure the requested username is valid
		if User.find_by_name(user)
			@messageu = "User name already taken"
		elsif user == nil
			@messageu = "If you want to register, you'll need a user name" 
		elsif user.length > 32
			@messageu = "User name too long"
		end #end user name checking

		#check passwords
		if pwd1 == nil
			@messagep = "You're going to need a password to register"
		elsif pwd2 == nil
			@messagep = "Please confirm your password"
		elsif !pwd1.eql?(pwd2)
			@messagep = "Your passwords do not match"
		elsif pwd1.length > 32
			@messagep = "Your password is too long"
		end #end password checking

		#if there were no error messages, create user
		if @messagep == nil && @messageu == nil
			@user = User.create do |u|
				u.name = user
				u.password = pwd1
			end

			#make sure the user was created
			if User.find_by_name(user)
				@login_token = 1
			end
		end
	end
end
