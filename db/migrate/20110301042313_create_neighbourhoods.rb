class CreateNeighbourhoods < ActiveRecord::Migration
  def self.up
    create_table :neighbourhoods do |t|
      t.string :district
      t.string :district_subsection
      t.string :neighbourhood

      t.timestamps
    end
  end

  def self.down
    drop_table :neighbourhoods
  end
end
