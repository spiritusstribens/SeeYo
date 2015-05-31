class Admin::YochatsController < ApplicationController
	before_action :set_yochat, :except => [:index]
	
	def index
		@page_title = 'Yochats List'
		@yochats = Yochat.page(params[:page]).per(10)
	end

	def show
	end

	def edit
		@page_title = 'Edit Alarm'
	end

	def update
		@yochat.update(yochat_params)
		Message.create(:user => @yochat.user, :msg_id => @yochat.id, :sender_id => current_user.id, :content => @yochat.content)
		redirect_to admin_yochats_url
		flash[:notice] = 'Yochat was successful alarmed!'
	end

	private
	def set_yochat
		@yochat = Yochat.find(params[:id])
	end

	def yochat_params
		params.require(:yochat).permit(:content)
	end
end
