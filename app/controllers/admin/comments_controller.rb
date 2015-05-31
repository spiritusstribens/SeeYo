class Admin::CommentsController < ApplicationController
	before_action :set_comment, :except => [:index]
	
	def index
		@page_title = 'Comments List'
		@comments = Comment.page(params[:page]).per(10)
	end

	def show
	end

	def edit
		@page_title = 'Edit Alarm'
	end

	def update
		@comment.update(comment_params)
		Message.create(:user => @comment.user, :msg_id => @comment.id, :sender_id => current_user.id, :content => @comment.content)
		redirect_to admin_comments_url
		flash[:notice] = 'Comment was successful alarmed!'
	end

	private
	def set_comment
		@comment = Comment.find(params[:id])
	end

	def comment_params
		params.require(:comment).permit(:content)
	end
end
