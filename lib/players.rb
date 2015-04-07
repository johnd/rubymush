require 'sequel'
require 'json'
require 'sequel/plugins/serialization'


class Player < Sequel::Model

  plugin :serialization, :json, :attributes

  # Location in the world.
  many_to_one :location

  # Ownership
  one_to_many :locations
  one_to_many :items
  one_to_many :exits

  def owned_objects
    self.locations + self.items + self.exits
  end

end
