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
  :email => "will@dateideas.ca",
  :gender =>"male",
  :birthday => "1980-01-01",
  :postal_code => "M3C3P5",
  :password => "E5WX7Ys89n05Kb"
)
# 
# User.create(
#   :first_name => "John",
#   :last_name => "Smith",
#   :username => "john",
#   :email => "john@gmail.com",
#   :gender =>"male",
#   :birthday => "1980-01-01",
#   :postal_code => "C2ZM3P",
#   :password => "test"
# )
# 
# User.create(
#   :first_name => "Jane",
#   :last_name => "Doe",
#   :username => "jane",
#   :email => "jane@dateideas.ca",
#   :gender =>"female",
#   :birthday => "1980-01-01",
#   :postal_code => "A1BC2D",
#   :password => "test"
# )
# 
# User.create(
#   :first_name => "Barack",
#   :last_name => "Obama",
#   :username => "obama",
#   :email => "obama@whitehouse.gov",
#   :gender =>"male",
#   :birthday => "1961-08-04",
#   :postal_code => "A1BC2D",
#   :password => "test"
# )
# 
# User.create(
#   :first_name => "First",
#   :last_name => "Lady",
#   :username => "first_lady",
#   :email => "first_lady@whitehouse.gov",
#   :gender =>"female",
#   :birthday => "1964-01-17",
#   :postal_code => "A1BC2D",
#   :password => "test"
# )