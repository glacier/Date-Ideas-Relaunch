class AddCategoriesToFarmedInfo < ActiveRecord::Migration
  def self.up
    add_column :farmed_infos, :categories, :string
    add_column :farmed_infos, :loaded, :integer
  end

  def self.down
    remove_column :farmed_infos, :loaded
    remove_column :farmed_infos, :categories
  end
end
