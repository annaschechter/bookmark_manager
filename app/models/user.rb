require 'bcrypt'

class User

	attr_reader :password
	attr_accessor :password_confirmation

	include DataMapper::Resource

	property :id, Serial
	property :email, String, :unique => true, :message => "This email is already taken"
	property :password_digest, Text
	property :password_token, Text, :default => " "
	property :password_token_timestamp, Time, :default => Time.now
	
	def password=(password)
		@password = password
	    self.password_digest = BCrypt::Password.create(password)
	end

	validates_confirmation_of :password
    validates_uniqueness_of :email

    def self.authenticate(email, password)
    	user = first(:email => email)
    	if user && BCrypt::Password.new(user.password_digest) == password
    		user
    	else
    		nil
    	end
    end


end