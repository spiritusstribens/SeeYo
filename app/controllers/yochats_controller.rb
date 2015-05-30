class YochatsController < ApplicationController
	before_filter :authenticate_user!
	before_action :set_user
	before_action :set_yochat, :only => [:show, :edit, :update, :destroy]

	def index
		@yochats = Yochat.page(params[:page]).per(5)
	end

	def show
		@comments = @yochat.comments
	end

	def new
		@yochat = @user.yochats.build
	end

	def create
		@yochat = @user.yochats.build(yochat_params)
		@yochat.like = 0;
		if @yochat.save
			redirect_to yochats_path
			flash[:notice] = "Yochat was successfully created!"
		else
			render :new
			flash[:alert] = "Yochat created faild!"
		end
	end

	def edit
	end

	def update
		if @yochat.update(yochat_modify)
			redirect_to yochat_path(@yochat)
			flash[:notice] = "Yochat was successfully updated!"
		else
			render :new
			flash[:alert] = "Yochat updated faild!"
		end
	end

	def destroy
		@yochat.destroy
		redirect_to yochats_path
		flash[:notice] = "Yochat was successfully deleted!"
	end

	private
	def set_user
		@user = current_user
	end

	def set_yochat
		@yochat = Yochat.find(params[:id])
	end

	def yochat_params
		params.require(:yochat).permit(:content, :share_with)
	end

	def yochat_modify
		params.require(:yochat).permit(:share_with)
	end

end
