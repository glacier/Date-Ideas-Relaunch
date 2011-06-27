class ChangeDatecartNotesToTextType < ActiveRecord::Migration
  def self.up
    change_column :datecarts, :notes, :text, :default => nil
  end

  def self.down
    change_column :datecarts, :notes, :string, :default => "Make it special!"
  end
end