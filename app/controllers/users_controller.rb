class UsersController < ApplicationController
	before_filter :authenticate_user!

	def index
		@user = current_user
		if @user.information.nil? && !@user.is_admin?
			@info = @user.create_information
		else
			@info = @user.information
		end
		@page_title = @user.username + '\'s home'
	end

	def show
		@user = User.find(params[:id]);
		@info = @user.information
		@yochats = @user.yochats.page(params[:page]).per(10)
	end

	def edit
		@user = current_user
		@info = @user.information
	end

	def update
		@user = current_user
		@info = @user.information
		if @info.update(info_params)
			redirect_to user_url(@user)
			flash[:notice] = 'Information was successfully updated!'
		else
			render :edit
			flash[:alert] = 'Information updated failed!'
		end
	end

	#YoFriend
	def add_fans
		uid = params[:user_id].nil?
		flash[:notice] = uid
		#@user = User.find(params[:user_id])
		#if (@user != current_user)
		#	Friend.create(:userf_id => current_user.id, :usert_id => @user.id)
			redirect_to user_url(current_user)
		#	flash[:notice] = 'Friend was successful added!'
		#else
		#	redirect_to user_url(@user)
		#end
	end

	private
	def info_params
		params.require(:information).permit(:gender, :location, :about, :birthday, :blog)
	end


end
