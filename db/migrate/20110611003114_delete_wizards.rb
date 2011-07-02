class DeleteWizards < ActiveRecord::Migration
  def self.up
    drop_table :wizards
  end

  def self.down
    create_table :wizards do |t|
      t.string :venue
      t.string :location
      t.integer :price_range
    end
  end
end
