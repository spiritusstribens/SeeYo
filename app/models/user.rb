class User < ActiveRecord::Base
	has_one :information
	has_many :yochats
	has_many :messages
	has_many :user_interests
	has_many :interests, :through => :user_interests
end
