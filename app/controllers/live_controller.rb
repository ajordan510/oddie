class LiveController < ApplicationController
    def index
        @title = 'SpectaFresh'
    end

    def login #page where the user can log in
        @title = 'Log In'
    end

    def home
        @title = 'SpectaFresh: Home'
    end

    def register_performance
        @title = 'Register Performance'
    end

    def post_register_performance

    end

    def post_login #comes here after they submit their log in
        user = User.authenticate(params[:login_val], params[:pass_val])
        if user
            session[:user_id] = user.id
            redirect_to :controller => 'live', :action => 'dashboard', :notice => "Logged In!"
        else
            flash[:bad_login]  = "Invalid email or password"
            render "login"
        end
    end

    def dashboard
        @title = 'Dashboard'
    end


    def create_user
        email = params[:live_signup_form][:email]  #done
        nickname = params[:live_signup_form][:nickname]  #done
        pass = params[:live_signup_form][:password]   #done
        pass_conf = params[:live_signup_form][:password_confirmation]
        age = params[:live_signup_form][:age]   #radio button above or below 18
        performer = params[:performer] #--not finding?
        genre_comedian = params[:genre_comedian]
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
        #id = params[:id]
        @new_live_user = User.new(:email => email, :nickname => nickname, :age => age, :performer => performer, 
        	:genre_comedian => genre_comedian, :genre_singer => genre_singer, :genre_musician => genre_musician,
        	:genre_dancer => genre_dancer, :genre_actor => genre_actor, :genre_speaker => genre_speaker, 
        	:genre_DJ => genre_DJ, :genre_other => genre_other, :description => description, :photo_name => @photo_name,
            :terms_conditions => terms_conditions, :password => pass, :password_confirmation => pass_conf)
        if @new_live_user.save
            #Kareem's added code
            session[:user_id] = @new_live_user.id
        	redirect_to :controller => 'live', :action => 'dashboard'
        else
        	flash[:confirm] = "Your account was created. Welcome to SpectaFresh."
            render :action => "sign_up"
        end

   end

   def create_performance
        #need to pass in timestamp, userid, and active flag
        #timestamp = ???
        genre = params[:genre]  #done
        title = params[:register_performance_form][:title]  #done
        description = params[:register_performance_form][:description]   #done
        #id = params[:id]
        #TODO: add in the timestamp info
        @new_registered_performance = Performance.new(:user_id => User.find(session[:user_id]).id, :genre => genre, 
            :title => title, :description => description, :active_flag => 'yes')
        if @new_registered_performance.save
            flash[:confirm_performance] = "Your performance has been registered. Good luck!"
            session[:performance_id] = performance.id
            redirect_to :controller => 'live', :action => 'dashboard'
        else
            #need to add some error handling here?
            render :action => "dashboard"
        end


   end

   
   #def redirect_signup
   #     redirect_to :controller => 'live', :action => 'sign_up'
   #end


   #def redirect_login
   #     redirect_to :controller => 'live', :action => 'login'
   #end

   def logout
        reset_session
        redirect_to :controller => 'live', :action => 'home'
   end

end