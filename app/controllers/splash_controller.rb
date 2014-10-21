class SplashController < ApplicationController
  def index
    @title = 'SpectaFresh'
    #@js_file_to_include = ['jquery.final-countdown.js', 'jquery.final-countdown.min.js', 'kinetic.js']
  end

  def create 
    email = params[:splash_email_form][:splash_email]
    role = params[:role]
    if email == nil
      redirect_to :controller => 'splash', :action => 'index' #check if email is valid in more robust way - @ sign etc.
    else
      if SplashUser.find_by_email(email) == nil
        @new_splash_user = SplashUser.create(:email => email, :role => role)
        SplashSuccess.splash_page_confirmation(email).deliver
      else
        flash[:email_taken] = "Email has already been issued. thanks for being so enthusiastic!"
      end
      flash[:confirm] = "Thank you for you interest.  We will keep you up to date on the SpectaFresh release."
      redirect_to :controller => 'splash', :action => 'index' #give the option to send requests to other people
    end
  end    

  def admin
    @title = 'SpectaFresh - Admin'
    @users = SplashUser.find(:all)
    @performers = SplashUser.find(:all, :conditions => {:role => "performer"})
    @audience = SplashUser.find(:all, :conditions => {:role => "audience"})
    @both = SplashUser.find(:all, :conditions => {:role => "both"})
  end

end