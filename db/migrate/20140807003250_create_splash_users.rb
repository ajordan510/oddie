class CreateSplashUsers < ActiveRecord::Migration
  def change
    create_table :splash_users do |t|
      t.text :email
      t.text :role
      t.timestamps
    end
  end
end
