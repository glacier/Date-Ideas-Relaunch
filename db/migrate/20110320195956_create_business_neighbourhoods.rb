class CreateBusinessNeighbourhoods < ActiveRecord::Migration
  def self.up
    create_table :business_neighbourhoods do |t|
      t.string :business_id
      t.string :neighbourhood

      t.timestamps
    end
  end

  def self.down
    drop_table :business_neighbourhoods
  end
end
