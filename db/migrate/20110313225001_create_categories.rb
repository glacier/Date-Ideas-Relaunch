class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :parent_name
      t.string :name
      t.string :display_name

      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
