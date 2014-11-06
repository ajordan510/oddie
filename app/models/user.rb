class User < ActiveRecord::Base
  #set the things we want to validate
  validates :email, :nickname, :password_confirmation, :performer, :terms_conditions, :presence =>true
#  validates :description, presence: true, if: :performer_yes?
  validates :email, :uniqueness => true
  validates :password, :confirmation => true

  #add a validate that checks that at least one genre is picked if they are indeed a performer
  def performer_yes?
    performer == "yes"
  end

end