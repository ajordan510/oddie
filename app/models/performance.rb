class Performance < ActiveRecord::Base
	
	#set the things we want to validate
	validates :genre, :title, :presence =>true
	#validates :description, presence: true, if: :performer_yes?
	#validates :description, :presence: true, if: :genre_other?   
	

	#should 

	#add a validate that checks that at least one genre is picked if they are indeed a performer
	def genre_other?
	  genre == "other"
	end

end