class CreateFarmedInfos < ActiveRecord::Migration
  def self.up
    create_table :farmed_infos do |t|
      t.string :neighbourhood
      t.integer :offset

      t.timestamps
    end
  end

  def self.down
    drop_table :farmed_infos
  end
end
