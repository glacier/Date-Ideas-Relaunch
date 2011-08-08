class AddSessionIdAndLastAccessTimeToDatecart < ActiveRecord::Migration
  def self.up
    add_column :datecarts, :session_id, :string
    add_column :datecarts, :last_access, :datetime
  end

  def self.down
    remove_column :datecarts, :session_id
    remove_column :datecarts, :last_access
  end
end
