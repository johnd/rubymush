require 'sequel'
require 'json'
require 'sequel/plugins/serialization'

class Player < Sequel::Model

  plugin :serialization, :json, :attributes
  plugin :validation_helpers

  def self.find_for_login(name)
    filter(Sequel.ilike(:name, name)).first
  end

  def validate
    super
    validates_unique :name, :message => "is already in use"
  end

  # Location in the world.
  many_to_one :room
  many_to_one :item
  many_to_one :player

  one_to_many :players
  one_to_many :items
  one_to_many :exits

  def owned_objects
    self.rooms + self.items + self.exits
  end

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
