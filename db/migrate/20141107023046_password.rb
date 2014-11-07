class Password < ActiveRecord::Migration
  def change
  	#add fields to the user table for the password_digest and salt combination
  	add_column :users, :password_digest, :string  
  	add_column :users, :salt, :float

  end
end
