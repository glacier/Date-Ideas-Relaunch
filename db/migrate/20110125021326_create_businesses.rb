class CreateBusinesses < ActiveRecord::Migration
  def self.up
    # db normalizations needed?
    # order the Excel columns according to this migration
    # does the order of columns listed in the migration matter in anyway?
    create_table :businesses do |t|
      t.string :venue_type
      t.string :logo
      t.string :name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :country
      t.float  :latitude
      t.float  :longitude
      t.string :photo_url, :default => "business.jpg"
      t.string :url
      t.string :phone_no
      t.string :website
      t.string :dna_excerpt
      # t.float :distance
      # t.float :avg_rating
      t.string :dna_neighbourhood
      t.string :dna_atmosphere
      t.string :dna_pricepoint # should be decimal?
      t.string :dna_category
      # add a column for food allergies?
      # add a column for accessibility?
      t.string :dna_dresscode
      t.string :dna_pictures
      t.string :dna_review
      # t.string :post_title # belongs in another table
      t.integer :dna_rating_conversation # ratings should be in another table?
      t.integer :dna_rating_convenience
      t.integer :dna_rating_comfort
      t.timestamps
    end 
  end

  def self.down
    drop_table :businesses
  end
end
