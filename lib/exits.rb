require 'sequel'
require 'json'
require 'sequel/plugins/serialization'

class Exit < Sequel::Model

  plugin :serialization, :json, :attributes

  # Location in the world.
  many_to_one :location

  # Destination
  many_to_one :destination, :class => :Location

  # Ownership
  many_to_one :owner, :class => :Player

end
