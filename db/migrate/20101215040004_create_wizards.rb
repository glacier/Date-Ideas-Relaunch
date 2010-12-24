class CreateWizards < ActiveRecord::Migration
  def self.up
    create_table :wizards do |t|
      t.string :venue
      t.string :location
      t.integer :priceRange

      t.timestamps
    end
  end

  def self.down
    drop_table :wizards
  end
end
