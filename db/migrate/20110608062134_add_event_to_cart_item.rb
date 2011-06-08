class AddEventToCartItem < ActiveRecord::Migration
  def self.up
    add_column :cart_items, :event_id, :integer
  end

  def self.down
    remove_column :cart_items, :event_id
  end
end
