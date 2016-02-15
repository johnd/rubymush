require 'sequel'
require 'json'
require 'sequel/plugins/serialization'

class Exit < Sequel::Model

  plugin :serialization, :json, :attributes

  # Location in the world.
  many_to_one :room
  many_to_one :item
  many_to_one :player

  # Destination
  many_to_one :destination_room, :class => :Room
  many_to_one :destination_item, :class => :Item
  many_to_one :destination_player, :class => :Player

  # Ownership
  many_to_one :owner, :class => :Player

  def location
    self.room || self.item || self.player
  end

  def location=(location)
    self.room = nil
    self.item = nil
    self.player = nil
    self.send(location.class.to_s.downcase.concat("=").to_sym, location)
  end

  def destination
    self.destination_room || self.destination_item || self.destination_player
  end

  def destination=(location)
    self.destination_room = nil
    self.destination_item = nil
    self.destination_player = nil
    self.send("destination_#{location.class.to_s.downcase}=".to_sym, location)
  end

end
