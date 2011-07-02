class CreateDataFarmers < ActiveRecord::Migration
  def self.up
    create_table :data_farmers do |t|
      t.integer :offset
      t.integer :saved

      t.timestamps
    end
  end

  def self.down
    drop_table :data_farmers
  end
end
