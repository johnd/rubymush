require_relative './db'

%w(rooms
   items
   exits
   players
).each do |model|
  require_relative "./#{model}"
end
