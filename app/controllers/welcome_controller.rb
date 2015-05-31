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
      redirect_to users_url
    end
  end
end
