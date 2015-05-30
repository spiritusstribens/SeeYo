class UsersController < ApplicationController
	before_filter :authenticate_user!
	before_action :set_user

	def index
		@page_title = @user.username + '\'s home'
	end

	private
	def set_user	
		@user = current_user
		if @user.username.nil?
			@user.username = @user.email.sub(/@.*$/, "")
		end
	end

end
