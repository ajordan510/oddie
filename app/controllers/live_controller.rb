

class LiveController < ApplicationController
  def index
    @title = 'SpectaFresh'
    #@js_file_to_include = ['jquery.final-countdown.js', 'jquery.final-countdown.min.js', 'kinetic.js']
  end

  def new
  	@title = 'New User'
  end

  def create 
    email = params[:live_signup_form][:email]  #done
    nickname = params[:live_signup_form][:nickname]  #done
    pass = params[:live_signup_form][:password]   #done
    pass_conf = params[:live_signup_form][:password_confirmation]
    age = params[:live_signup_form][:age]   #radio button above or below 18
    performer = params[:performer] #--not finding?
    genre_comedian = params[:genre_comedian ]
    genre_singer = params[:genre_singer]
    genre_musician = params[:genre_musician]
    genre_dancer = params[:genre_dancer]
    genre_actor = params[:genre_actor]
    genre_speaker = params[:genre_speaker]
    genre_DJ = params[:genre_DJ]
    genre_other = params[:genre_other]
    description = params[:live_signup_form][:description]
    terms_conditions = params[:terms_conditions]
    @photo_name = params[:live_signup_form][:upload_photo].original_filename
    path_for_upload = File.join(Rails.root.to_s+"/public/images",@photo_name)
    File.open(path_for_upload, "wb"){|fff| fff.write(params[:live_signup_form][:upload_photo].read)} 
    id = params[:id]
    @new_live_user = User.create(:email => email, :nickname => nickname, :password => pass, 
    	:password_confirmation => pass_conf, :age => age, :performer => performer, 
    	:genre_comedian => genre_comedian, :genre_singer => genre_singer, :genre_musician => genre_musician,
    	:genre_dancer => genre_dancer, :genre_actor => genre_actor, :genre_speaker => genre_speaker, 
    	:genre_DJ => genre_DJ, :genre_other => genre_other, :description => description, :photo_name => @photo_name,
        :terms_conditions => terms_conditions)

    	if @new_live_user.valid?
    		redirect_to :controller => 'splash', :action => 'index'
    	else
    		render :action => "sign_up"
    	end
   end
  
 # def admin
 #   @title = 'SpectaFresh - Admin'
 #   @users = SplashUser.find(:all)
 #  @performers = SplashUser.find(:all, :conditions => {:role => "performer"})
 #   @audience = SplashUser.find(:all, :conditions => {:role => "audience"})
 #   @both = SplashUser.find(:all, :conditions => {:role => "both"})
 # end

end