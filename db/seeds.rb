# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.delete_all

User.create(
  :first_name => "demo",
  :last_name => "account",
  :username => "demo",
  :email => "demo@dateideas.ca",
  :gender =>"male",
  :birthday => "1980-01-01",
  :postal_code => "M3C3P5",
  :password => "2J2866Nt874G7W"
)

User.create(
  :first_name => "Grace",
  :last_name => "Li",
  :username => "grace",
  :email => "grace@dateideas.ca",
  :gender =>"female",
  :birthday => "1980-01-01",
  :postal_code => "C2ZM3P",
  :password => "2J2866Nt874G7W"
)
 
User.create(
  :first_name => "Alvin",
  :last_name => "Yap",
  :username => "alvin",
  :email => "alvin@dateideas.ca",
  :gender =>"male",
  :birthday => "1980-01-01",
  :postal_code => "A1BC2D",
  :password => "2J2866Nt874G7W"
)

# Admin account seed
User.create(
  :first_name => "Will",
  :last_name => "Lam",
  :username => "admin",
  :email => "admin@dateideas.ca",
  :gender =>"male",
  :birthday => "1980-01-01",
  :postal_code => "A1BC2D",
  :password => "n1>7wB1ubWvMuMI"
)

Role.create(
  :name => "admin",
)

Role.create(
  :name => "user",
)

Assignment.create(
  :user_id => 1,
  :role_id => 2
)
Assignment.create(
  :user_id => 2,
  :role_id => 2
)
Assignment.create(
  :user_id => 3,
  :role_id => 2
)

Assignment.create(
  :user_id => 4,
  :role_id => 1
)