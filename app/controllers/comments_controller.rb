class CommentsController < ApplicationController
	before_filter :authenticate_user!
	before_action :set_user_yochat
	
	def new
		@comment = @yochat.comments.build
	end

	def create
		@comment = @yochat.comments.build(comment_params)
		@comment.like = 0
		@comment.user = @user
		if @comment.save
			Message.create(:user => @yochat.user, :classes => "yochat", :msg_id => @comment.id, :sender_id => @user.id)
			redirect_to yochat_url(@yochat)
			flash[:notice] = "Comment was successfully created!"
		else
			render :new
			flash[:alert] = "Comment created faild!"
		end
	end

	def edit
		@comment = @yochat.comments.create(:like => 0, :user => @user, :ater_id => params[:id])
		Message.create(:user_id => params[:id], :classes => 'comment', :msg_id => @comment.id, :sender_id => @user.id)
	end

	def update
		@comment = Comment.find(params[:id])
		if @comment.update(comment_params)
			redirect_to yochat_url(@yochat)
			flash[:notice] = "Comment was successfully created!"
		else
			render :edit
			flash[:alert] = "Comment created faild!"
		end
	end

	def destroy
		@comment = Comment.find(params[:id])
		@comment.destroy
		redirect_to yochat_url(@yochat)
		flash[:notice] = "Comment was successfully deleted!"
	end

	private
	def set_user_yochat
		@user = current_user
		@yochat = Yochat.find(params[:yochat_id])
	end

	def comment_params
		params.require(:comment).permit(:content)
	end

end
