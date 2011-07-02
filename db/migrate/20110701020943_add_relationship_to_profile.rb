class AddRelationshipToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :relationship_status, :string
    add_column :profiles, :sig_other_name, :string
  end

  def self.down
    remove_column :profiles, :sig_other_name
    remove_column :profiles, :relationship_status
  end
end
