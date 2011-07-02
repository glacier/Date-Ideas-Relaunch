class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      # model association to the user model
      # equivalent to t.integer :supplier_id
      t.references :user
      t.string :avatar_url
      t.date :anniversary #this is optional
      t.string :about_me
      t.timestamps
    end
    add_index :profiles, :user_id
  end

  def self.down
    drop_table :profiles
  end
end
