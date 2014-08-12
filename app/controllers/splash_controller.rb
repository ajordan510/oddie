class SplashController < ApplicationController
  def index
    @title = 'Oddie'
  end

  def create
    email = params[:splash_email_form][:splash_email]
    if email == nil
      redirect_to :controller => 'splash', :action => 'index' #check if email is valid in more robust way - @ sign etc.
    else
      if SplashUser.find_by_email(email) == nil
        @new_splash_user = SplashUser.create(:email => email)
      else
        flash[:email_taken] = "Email has already been issued. thanks for being so enthusiastic!"
      end
      redirect_to :controller => 'splash', :action => 'confirmation' #give the option to send requests to other people
    end
  end    

end