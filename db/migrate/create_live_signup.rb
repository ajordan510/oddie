class CreateLiveUsers < ActiveRecord::Migration
  #set the things we want to validate
  validates :email, :nickname, :password_confirmation, :performer, :presence =>true
  validates :email, :uniqueness => true
  validates :password, :confirmation => true

  def change
    create_table :live_users do |t|
      #bool: y/n, 
      t.text :email
      t.text :nickname
      t.text :password
      t.text :password_confirmation
      t.text :age    #??
      t.string :photo
      t.text :performer
      t.text :genre_comedian
      t.text :genre_singer
      t.text :genre_musician
      t.text :genre_dancer
      t.text :genre_actor
      t.text :genre_speaker
      t.text :genre_DJ
      t.text :genre_other
      t.text :description
      t.integer :id
      #t.text :gender
      #t.text :city
      #t.text :state
      #t.bool :special_equipment
      t.timestamps
    end
  end
end