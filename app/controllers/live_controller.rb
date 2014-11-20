class LiveController < ApplicationController
    def index
        @title = 'SpectaFresh'
    end

    def login #page where the user can log in
        @title = 'Log In'
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
        scheduler_dates
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
        @new_live_user = User.new(:email => email, :nickname => nickname, :age => age, :performer => performer, 
        	:genre_comedian => genre_comedian, :genre_singer => genre_singer, :genre_musician => genre_musician,
        	:genre_dancer => genre_dancer, :genre_actor => genre_actor, :genre_speaker => genre_speaker, 
        	:genre_DJ => genre_DJ, :genre_other => genre_other, :description => description, :photo_name => @photo_name,
            :terms_conditions => terms_conditions, :password => pass, :password_confirmation => pass_conf)
        if @new_live_user.save
            session[:user_id] = @new_live_user.id
        	redirect_to :controller => 'live', :action => 'dashboardnew'
        else
        	render :action => "sign_up"
        end

   end

<<<<<<< HEAD
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
=======
   # THIS IS AN ALEX DEFINED METHOD THAT IS TO BE CALLED FORM THE DASHBOARD INDEX 
   def scheduler_dates
        #allow variables to be accessible in the dashboard controller by adding "@" before the variable name -- always include, not just at create
        @weeks_shown = 3;
        @today_datetime = DateTime.now
        #monday = 1; tuesday = 2; wednesday = 3; thursday = 4; friday = 5; saturday = 6; sunday = 7;
        @days_of_week_integer = [3, 5, 7]       
        @start_time_hour = 19; #military time - hours 0..23
        @start_time_min = 45; #minute of the first show
        @num_shows_a_day = 2; #number of shows to occur every day (base zero - subtract one frm actual number...i.e. 2 is for 3 shows a day)
        @length_of_show = 10; #min length of each show
        @intermission_time = 5; #mins between shows

        @time_array = []
        @num_slots_to_show_table = @days_of_week_integer.count*@num_shows_a_day
        #the placeholder day is going to represent the DateTime for the first show, but will be used mostly for getting time array with hours and mins
        #that can be used in the loop to define the years worth of slots for setting hour and min of performances
        placeholder_day = DateTime.new(@today_datetime.year, @today_datetime.month, @today_datetime.day, @start_time_hour, @start_time_min)
        
        
        for jj in 0..@num_shows_a_day
            @time_array << placeholder_day + ((@length_of_show+@intermission_time)*jj).minutes
        end 
        
        @days_of_week = [];
        @table_slots = [];
       
        #create a years worth of slots based off of day of the weeks and time, start from todays date...put into a big array
        start_date = @today_datetime-1.weeks; #start with last week
        jj=0;
        while jj < 5 do
            for kk in 0...@days_of_week_integer.count
                for ll in 0..@num_shows_a_day
                    @day_slot = start_date + jj.weeks 
                    n_week = @day_slot.next_week;
                    @date_with_day = @day_slot - (7-@days_of_week_integer[kk]).days
                    #need to make it so that the day is only going to be on the days of the week we are interested in
                    @year_slot_present = DateTime.new(@date_with_day.year, @date_with_day.month, @date_with_day.day, @time_array[ll].hour, @time_array[ll].minute)
                    if @today_datetime < @year_slot_present
                        #then this means that we are now in the future -- this 
                        @table_slots << @year_slot_present
                    end
                end
            end
            jj = jj+1;
        end
        #the following will pull the dates that we are interested in
        @specific_dates = [];
        @days_of_week_integer.each do |dd|
            @specific_dates << @table_slots[0].next_week - (8-dd).days
>>>>>>> 4b6f9f0065107e29c0a51f1ad3af7d66e1cb4b74
        end

        @week_slots = [];
        @days_of_week_integer.each do |day_int|
            if day_int == 1
                @days_of_week << 'Monday' 
            elsif day_int == 2
                @days_of_week << 'Tuesday'
            elsif day_int == 3
                @days_of_week << 'Wednesday'
            elsif day_int == 4
                @days_of_week << 'Thursday'
            elsif day_int == 5
                @days_of_week << 'Friday'
            elsif day_int ==6
                @days_of_week << 'Saturday'
            else
                @days_of_week << 'Sunday'
            end     
        end

   end

end