class AddDetailsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthday, :date
    add_column :users, :postal_code, :string
    add_column :users, :gender, :string
  end

  def self.down
    remove_column :users, :last_name
    remove_column :users, :first_name
    remove_column :users, :username
    remove_column :users, :birthday, :date
    remove_column :users, :postal_code, :string
    remove_column :users, :gender, :string
  end
end
