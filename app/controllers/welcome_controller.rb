class WelcomeController < ApplicationController
  before_action :flash_database
	def index
    if !user_signed_in?
      redirect_to new_user_session_url
    else
      user = current_user
      if user.username.nil?
        user.username = user.email.sub(/@.*$/,"")
        user.save
      end
      if user.is_admin?
        redirect_to admin_users_url
      else
        redirect_to users_url
      end
    end
  end

	private
	def flash_database
		Friend.all.each do |f|
			if User.find_by_id(f.userf_id).nil? || User.find_by_id(f.usert_id).nil?
				f.destroy
			end
		end
		Message.all.each do |m|
			if User.find_by_id(m.sender_id).nil?
				m.destroy
			end
		end
		Comment.all.each do |c|
			if User.find_by_id(c.ater_id).nil?
				c.destroy
			end
		end
	end
end
