class Admin::UsersController < ApplicationController
	before_action :set_user, :only => [:show, :destroy]

	def index
		@page_title = 'Yokers List'
		@users = User.page(params[:page]).per(10)
	end

	def show
		@page_title = @user.name + '\'s Profile'
	end

	def destroy
		@user.destroy
		redirect_to admin_users_url
		flash[:notice] = 'User was successful deleted!'
	end

	private
	def set_user
		@user = User.find(params[:id])
	end

end
