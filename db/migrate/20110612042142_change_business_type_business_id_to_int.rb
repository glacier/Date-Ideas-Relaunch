class ChangeBusinessTypeBusinessIdToInt < ActiveRecord::Migration
  def self.up
    change_column :business_types, :business_id, :integer
  end

  def self.down
    change_column :business_types, :business_id, :string
  end
end
