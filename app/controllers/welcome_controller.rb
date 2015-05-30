class WelcomeController < ApplicationController
	def index
		if !user_signed_in?
			redirect_to new_user_session_url
		else
			redirect_to users_url
		end
	end
end
