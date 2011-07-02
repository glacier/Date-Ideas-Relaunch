# coding: utf-8
class AddMontrealNeighbourhoods < ActiveRecord::Migration
  def self.up
    Neighbourhood.create(:city=>'Montréal', :country=>'Canada')
  end
  def self.down
  end
end
