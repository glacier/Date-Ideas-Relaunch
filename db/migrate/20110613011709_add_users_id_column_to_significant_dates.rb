class AddUsersIdColumnToSignificantDates < ActiveRecord::Migration
  def self.up
    add_column :significant_dates, :user_id, :integer
  end

  def self.down
    remove_column :significant_dates, :user_id
  end
end
