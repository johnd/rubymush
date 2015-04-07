require_relative './db'

%w(locations
   items
   exits
   players
).each do |model|
  require_relative "./#{model}"
end
