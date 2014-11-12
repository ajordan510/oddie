class LiveController < ApplicationController
    def index
        @title = 'SpectaFresh'
    end

    def login #page where the user can log in
        @title = 'Log In'
    end

    def post_login #comes here after they submit their log in
        @logged_in_user = User.find_by_email(params[:login_val]) #find the current user
        password_in = params[:pass_val]
        if @logged_in_user.nil?
            flash[:bad_login] = "did not find in database"#{}"Username/Password Combination is not valid"
            render :action => :login
        else
            if @logged_in_user.password_valid?(password_in)
                @logged_in_id = @logged_in_user.id 
                session[:user_id]   = @logged_in_id
                redirect_to :controller => 'live', :action =>'dashboard', :id=> @logged_in_id.to_s()
            else
                flash[:bad_login] = "password did not match"
                render :action => :login #send back to a new page to update - render to keep errors
            end
        end
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
        @new_live_user = User.create(:email => email, :nickname => nickname, :age => age, :performer => performer, 
        	:genre_comedian => genre_comedian, :genre_singer => genre_singer, :genre_musician => genre_musician,
        	:genre_dancer => genre_dancer, :genre_actor => genre_actor, :genre_speaker => genre_speaker, 
        	:genre_DJ => genre_DJ, :genre_other => genre_other, :description => description, :photo_name => @photo_name,
            :terms_conditions => terms_conditions, :password => pass, :password_confirmation => pass_conf)
        if @new_live_user.valid?
        	redirect_to :controller => 'live', :action => 'dashboardnew'
        else
        	render :action => "sign_up"
        end

   end

   def redirect_signup
        redirect_to :controller => 'live', :action => 'sign_up'
   end


   def redirect_login
        redirect_to :controller => 'live', :action => 'login'
   end

end