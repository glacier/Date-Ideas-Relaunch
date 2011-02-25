class CreateDatecarts < ActiveRecord::Migration
  def self.up
    create_table :datecarts do |t|
      
      t.timestamps
    end
  end

  def self.down
    drop_table :datecarts
  end
end
