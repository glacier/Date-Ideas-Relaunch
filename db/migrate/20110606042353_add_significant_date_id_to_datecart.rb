class AddSignificantDateIdToDatecart < ActiveRecord::Migration
  def self.up
    add_column :datecarts, :significant_date_id, :integer
  end

  def self.down
    remove_column :datecarts, :significant_date_id
  end
end
