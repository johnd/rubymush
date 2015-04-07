require 'sequel'
require 'json'
require 'sequel/plugins/serialization'

class Item < Sequel::Model

  plugin :serialization, :json, :attributes

  # Location in the world.
  many_to_one :location

  # Ownership
  many_to_one :owner, :class => :Player

end
