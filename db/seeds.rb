# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
User.delete_all

User.create(
  :first_name => "Grace",
  :last_name => "Li",
  :username => "grace",
  :email => "grace@dateideas.ca",
  :gender =>"female",
  :birthday => "1984-10-05",
  :postal_code => "M3C3P5",
  :password => "test"
)

User.create(
  :first_name => "Jane",
  :last_name => "Doe",
  :username => "jane",
  :email => "jane@dateideas.ca",
  :gender =>"female",
  :birthday => "1980-01-01",
  :postal_code => "A1BC2D",
  :password => "test"
)