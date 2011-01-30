class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.string :venue_type
      t.string :venue_logo
      t.string :venue_name
      t.string :venue_address1
      t.string :venue_city
      t.string :venue_prov
      t.string :venue_postal
      t.string :venue_country
      t.string :venue_phone
      t.string :venue_website
      t.string :venue_dna_neighbourhood
      t.string :venue_dna_atmosphere
      t.string :venue_dna_pricepoint
      t.string :venue_dna_foodcategory
      t.string :venue_dna_dresscode
      t.string :venue_dna_pictures
      t.string :venue_post_title
      t.string :venue_dna_review
      t.integer :venue_dna_conversation
      t.integer :venue_dna_convenience
      t.integer :venue_dna_comfort
      t.timestamps
    end 
  end

  def self.down
    drop_table :venues
  end
end
