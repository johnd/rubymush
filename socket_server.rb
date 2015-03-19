# This is a POC of a simple socket server.
#
# The idea is to allow multiple clients to connect and provide a basic UI to insert and retrieve items from a redis DB.

# Part one: listen on a socket, do a thing for each client.


require 'socket'
require 'pp'

require 'bundler/setup'
require 'redis'

redis = Redis.new

server = TCPServer.open(2000)
@clients = []
loop do
  Thread.start(server.accept) do |client|
    @clients << client
    puts "Connection from #{client.addr}"
    while line = client.gets
      if line.chop == "quit"
        @clients.delete client
        client.close
      elsif line[0] == ":"
        key = line.chop[1..-1]
        puts "Key: #{key}"
        client.puts redis.get(key)
      else
        parts = line.chop.split("=")
        if parts.length != 2
          client.puts "I don't understand?"
        else
          redis.set parts.first, parts.last
          @clients.each do |c|
            c.puts "Set #{parts.first} to #{parts.last}."
          end
          puts redis.get(parts.first)
        end
      end
    end
    @clients.delete client
    client.close
  end
end
