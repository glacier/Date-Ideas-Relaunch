class CreateBusinessNeighbourhoods < ActiveRecord::Migration
  def self.up
    create_table :business_neighbourhoods do |t|
      t.integer :business_id
      t.integer :neighbourhood_id

      t.timestamps
    end
  end

  def self.down
    drop_table :business_neighbourhoods
  end
end
