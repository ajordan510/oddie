class User < ActiveRecord::Base
	#set the things we want to validate
	validates :email, :nickname, :password_confirmation, :performer, :terms_conditions, :presence =>true
	#validates :description, presence: true, if: :performer_yes?
	validates :email, :uniqueness => true
	validates :password, :confirmation => true

	#add a validate that checks that at least one genre is picked if they are indeed a performer
	#def performer_yes?
	#  performer == "yes"
	#end

	  #---- add in code to encrypyt/salt/validate password ---- #
	def password
		@pass_virt_at #get the virtual atribute for password
	end

	def password_valid?(input_password) #return boolean true or false after checking
		salted = self.salt.to_s
		if input_password.nil? #did they send in a password
			errors.add(:user, "Password was not input")
		elsif self.password_digest == Digest::SHA1.hexdigest(input_password+salted)
			return true #return the boolean saying they matched
		else
			errors.add(:user, "Incorrect Username/Password Combination") #add in a new error
			return false #set the boolean to false
		end
	end

	def password=(pass_in) #setter for the virtual attribute
		self.salt = rand #generate the salt
		salt_string = self.salt.to_s #convert to a string
		self.password_digest = Digest::SHA1.hexdigest(pass_in+salt_string) #hash the pass string
		@pass_virt_at = pass_in
	end

end