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
            @user = User.find(session[:user_id])
            if @user.performer == 'yes'
                @is_performer = 'block'
            else
                @is_performer = 'none'
            end
            active_perf = Performance.find_by_user_id(session[:user_id])
            if active_perf != nil
                @sched_performance = DateTime.new(active_perf.year.to_i, active_perf.month.to_i, active_perf.day.to_i, active_perf.hour.to_i, active_perf.minute.to_i)
            end
            scheduler_dates
        end


        def create_user
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
            path_for_upload = File.join(Rails.root.to_s+"/app/assets/images",@photo_name)
            File.open(path_for_upload, "wb"){|fff| fff.write(params[:live_signup_form][:upload_photo].read)} 
            id = params[:id]
            @new_live_user = User.new(:email => email, :nickname => nickname, :age => age, :performer => performer, 
            	:genre_comedian => genre_comedian, :genre_singer => genre_singer, :genre_musician => genre_musician,
            	:genre_dancer => genre_dancer, :genre_actor => genre_actor, :genre_speaker => genre_speaker, 
            	:genre_DJ => genre_DJ, :genre_other => genre_other, :description => description, :photo_name => @photo_name,
                :terms_conditions => terms_conditions, :password => pass, :password_confirmation => pass_conf)
            if @new_live_user.save
                session[:user_id] = @new_live_user.id
            	redirect_to :controller => 'live', :action => 'dashboard'
            else
            	render :action => "sign_up"
            end
       end


       def create_performance
            #need to pass in timestamp, userid, and active flag
            #timestamp = ???
            month = params[:month]
            day = params[:day]
            year = params[:year]
            hour = params[:hour]
            minute = params[:minute]

            genre = params[:genre]  #done
            title = params[:register_performance_form][:title]  #done
            description = params[:register_performance_form][:description]   #done
            #id = params[:id]
            #TODO: add in the timestamp info
            @new_registered_performance = Performance.new(:user_id => User.find(session[:user_id]).id, :genre => genre, 
                :title => title, :description => description, :active_flag => 'yes', :month => month,  :day => day, :year => year, :hour => hour, :minute => minute  )
            if @new_registered_performance.save
                flash[:confirm_performance] = "Your performance has been registered. Good luck!"
                session[:performance_id] = @new_registered_performance.id
                redirect_to :controller => 'live', :action => 'dashboard'
            else
                #need to add some error handling here?
                render :action => "dashboard"
            end
        end

        def update_user #action for modifying user info from database
            photo_name = params[:update_user_form][:upload_photo];
            nickname = params[:update_user_form][:nickname];
            age = params[:update_user_form][:age];
            comedian =  params[:genre_comedian];
            singer =  params[:genre_singer];
            musician =  params[:genre_musician];
            dancer =  params[:genre_dancer];
            actor =  params[:genre_actor];
            speaker =  params[:genre_speaker];
            dj =  params[:genre_DJ];
            other =  params[:genre_other];
            performer = params[:performer];
            description = params[:update_user_form][:description]
            #update the database value;
            @user = User.find(session[:user_id])
            if photo_name != nil
                photo_name = params[:update_user_form][:upload_photo].original_filename;
                @user.photo_name = photo_name
                path_for_upload = File.join(Rails.root.to_s+"/app/assets/images",photo_name)
                File.open(path_for_upload, "wb"){|fff| fff.write(params[:update_user_form][:upload_photo].read)} 
            end
            @user.nickname = 'test';
            # @user.age = age;
            # @user.genre_comedian = comedian;
            # @user.genre_singer = singer;
            # @user.genre_musician = musician;
            # @user.genre_dancer = dancer;
            # @user.genre_actor = actor;
            # @user.genre_speaker = speaker;
            # @user.genre_DJ = dj;
            # @user.genre_other = other;
            # @user.description = description;
            @user.save
            redirect_to :controller => 'live', :action => 'dashboard'
            #if @user.update_attributes()
        end

   # THIS IS AN ALEX DEFINED METHOD THAT IS TO BE CALLED FORM THE DASHBOARD INDEX 
       def scheduler_dates
            #allow variables to be accessible in the dashboard controller by adding "@" before the variable name -- always include, not just at create
            @weeks_shown = 3;
            @today_datetime = DateTime.now
            cwday = DateTime.now.cwday
            #monday = 1; tuesday = 2; wednesday = 3; thursday = 4; friday = 5; saturday = 6; sunday = 7;
            @days_of_week_integer = [3, 4, 6]  #keep in ascending order     
            @start_time_hour = 17; #military time - hours 0..23
            @start_time_min = 45; #minute of the first show
            @num_shows_a_day = 2; #number of shows to occur every day (base zero - subtract one frm actual number...i.e. 2 is for 3 shows a day)
            @length_of_show = 10; #min length of each show
            @intermission_time = 5; #mins between shows
            
            @num_slots_to_show_table = @days_of_week_integer.count*@num_shows_a_day
            
            days_greater_count = 0;
            equal_day_flag = 0;
            @days_of_week_integer.each do |weekday|
                if @today_datetime.cwday < weekday
                    days_greater_count = days_greater_count+1
                elsif @today_datetime.cwday == weekday
                    equal_day_flag = 1;
                end
            end
            @equal_day_flag = equal_day_flag
            #(0) - set up some builders that can be used to for dateTimes
            @days_greater_count = days_greater_count
            placeholder_day = DateTime.new(@today_datetime.year, @today_datetime.month, @today_datetime.day, @start_time_hour, @start_time_min)
            @hour_array = [];
            @min_array = [];
            @time_array = [];
            for jj in 0..@num_shows_a_day
                @time_array << placeholder_day + ((@length_of_show+@intermission_time)*jj).minutes
                @hour_array << @time_array[jj].hour
                @min_array << @time_array[jj].min
            end 

            # @hour_array2 = [];
            # @min_array2 = [];
            # specific_dates = [];
            # for jj in 0..@num_shows_a_day
            #     time_show =  @start_time_hour*100 + @start_time_min + jj*(@length_of_show+@intermission_time)
            #     hour_show =  (time_show/100).truncate
            #     min_show = time_show - hour_show*100
            #     @hour_array2 << hour_show
            #     @min_array2 << min_show
            #     @hour_array << 2#hour_show
            #     @min_array << 2#min_show
            # end
            #(1) - figure out where we are in regards to days with show
            specific_dates = []; #array with the dates for the table
            if equal_day_flag == 1
                for jj in 0..@num_shows_a_day
                    show_DateTime = DateTime.now
                    hour_new = @hour_array[jj]
                    min_new = @min_array[jj]
                    show_DateTime = show_DateTime.change(hour: hour_new, min: min_new)
                    specific_dates << show_DateTime
                end
            end

            if days_greater_count == @days_of_week_integer.count
                @days_of_week_integer.each do |cwday_perf|
                day_change = cwday_perf - cday;
                    for jj in 0..@num_shows_a_day        
                        show_DateTime = DateTime.now + day_change.days
                        hour_new = @hour_array[jj]
                        min_new = @min_array[jj]
                        show_DateTime = show_DateTime.change(hour: hour_new, min: min_new)
                        specific_dates << show_DateTime
                    end
                end
            elsif days_greater_count == 0 && equal_day_flag == 0 #no performances left this week
                @days_of_week_integer.each do |cwday_perf|
                    day_change = (7-cwday) + cwday_perf
                    for jj in 0..@num_shows_a_day        
                        show_DateTime = DateTime.now + day_change.days
                        hour_new = @hour_array[jj]
                        min_new = @min_array[jj]
                        show_DateTime = show_DateTime.change(hour: hour_new, min: min_new)
                        specific_dates << show_DateTime
                    end
                end
            else 
                next_week_dates = @days_of_week_integer.count - days_greater_count;
                this_week_dates = @days_of_week_integer.count - next_week_dates;
                #first set up this weeks dates
                @in_here = 'yes'
                for jj in 1..this_week_dates
                    day_week = @days_of_week_integer[@days_of_week_integer.count - this_week_dates + (jj-1)]
                    day_change = day_week - cwday;
                    for kk in 0..@num_shows_a_day
                        show_DateTime = DateTime.now + day_change.days
                        hour_new = @hour_array[kk]
                        min_new = @min_array[kk]
                        show_DateTime = show_DateTime.change(hour: hour_new, min: min_new)
                        specific_dates << show_DateTime
                    end
                end
                for jj in 1..next_week_dates
                    day_week = @days_of_week_integer[jj-1]
                    day_change = 7 - (cwday-day_week);
                    for kk in 0..@num_shows_a_day
                        show_DateTime = DateTime.now + day_change.days
                        hour_new = @hour_array[kk]
                        min_new = @min_array[kk]
                        show_DateTime = show_DateTime.change(hour: hour_new, min: min_new)
                        specific_dates << show_DateTime
                    end
                end
            end            
            @this_week_dates = this_week_dates
            @specific_dates = specific_dates;
            @combined_current_time = @today_datetime.strftime('%k%M').to_i
            @combined_time = [];
            specific_dates.each do |s_date|
                @combined_time << s_date.strftime('%k%M').to_i
            end
       end
end
