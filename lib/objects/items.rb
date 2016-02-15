require 'sequel'
require 'json'
require 'sequel/plugins/serialization'

class Item < Sequel::Model

  plugin :serialization, :json, :attributes

  # Location in the world.
  many_to_one :room
  many_to_one :item
  many_to_one :player

  one_to_many :players
  one_to_many :items
  one_to_many :exits

  # Ownership
  many_to_one :owner, :class => :Player

  def contents
    self.players + self.items + self.exits
  end

  def location
    self.room || self.item || self.player
  end

  def location=(location)
    self.room = nil
    self.item = nil
    self.player = nil
    self.send(location.class.to_s.downcase.concat("=").to_sym, location)
  end

end
