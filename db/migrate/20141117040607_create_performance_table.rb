class CreatePerformanceTable < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.text :title
      t.text :genre
      t.text :description    #??
      t.text :active_flag
      t.text :month
      t.text :day
      t.text :year
      t.text :hour
      t.text :minute
      t.integer :user_id
      
      #t.date_time :timestamp from alex???


      t.timestamps
    end
  end
end
