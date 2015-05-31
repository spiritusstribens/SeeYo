class WelcomeController < ApplicationController
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
end
