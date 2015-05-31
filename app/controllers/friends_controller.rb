class FriendsController < ApplicationController
	before_filter :authenticate_user!
	before_action :set_user

	def index
		if @user == current_user
			@friends = Array.new
			focus = Friend.where(['userf_id=?', current_user.id])
			focus.each do |fo|
				if Friend.exists?(:userf_id => fo.usert_id, :usert_id => current_user.id)
					@friends.push(fo)
				end
			end
		else
			redirect_to user_url(@user)
		end
	end

	def create
		focus_u = Friend.where(['(userf_id=? and usert_id=?)', current_user.id, @user.id])
		if focus_u.count > 0
			focus_u.each do |f|
				f.destroy
			end
			flash[:notice] = 'Friend was successful cancled!'
			redirect_to user_url(@user)
		else
			Friend.create(:userf_id => current_user.id, :usert_id => @user.id)
			flash[:notice] = 'Friend was successful added!'
			redirect_to user_url(@user)
		end
	end

	def show_focus
		@focus = Friend.where(['userf_id=?', @user.id])
	end

	def show_fans
		@fans = Friend.where(['usert_id=?', @user.id])
	end

	def destroy
		@relation = Friend.find(params[:id])
		@relation.destroy
		flash[:notice] = 'Relationship was successful deleted!'
		redirect_to :back
	end

	private
	def set_user
		@user = User.find(params[:user_id])
	end

end
