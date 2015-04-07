require 'sequel'
require 'json'
require 'sequel/plugins/serialization'

class Location < Sequel::Model

  plugin :serialization, :json, :attributes


  # Ownership
  many_to_one :owner, :class => :Player

  one_to_many :players
  one_to_many :items
  one_to_many :exits

  def contents
    self.players + self.items + self.exits
  end


end
