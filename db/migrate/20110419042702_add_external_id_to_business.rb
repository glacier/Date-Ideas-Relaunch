class AddExternalIdToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :external_id, :string
    add_column :businesses, :deleted, :boolean
  end

  def self.down
    remove_column :businesses, :deleted
    remove_column :businesses, :external_id
  end
end
