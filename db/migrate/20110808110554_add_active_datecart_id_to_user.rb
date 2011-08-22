class AddActiveDatecartIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :active_datecart_id, :integer
    add_index :users, :active_datecart_id, :unique => true
  end

  def self.down
    remove_column :users, :active_datecart_id
  end


end
