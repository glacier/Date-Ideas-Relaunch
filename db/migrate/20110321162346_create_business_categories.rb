class CreateBusinessCategories < ActiveRecord::Migration
  def self.up
    create_table :business_categories do |t|
      t.integer :business_id
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :business_categories
  end
end
