class LoginController < ApplicationController
	def logged
		@login_token = 0
		usr = params[:username]
		pwd = params[:password]
		@user = User.find_by_name(usr)
		@login_token = 1 unless usr == nil || !pwd.eql?(@user.password)
	end
end
