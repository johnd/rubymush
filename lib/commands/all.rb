%w(base
   core
).each do |file|
  require_relative "./#{file}"
end
