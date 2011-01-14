class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      # model association to the user model
      # equivalent to t.integer :supplier_id
      t.references :user
      t.string :avatar_url
      t.date :anniversary
      t.string :about_me
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
