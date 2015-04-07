require 'socket'
require 'redis'
require 'pp'

module RubyMUSH
  class Server

    class << self

      def run
        @redis = Redis.new
        @server = TCPServer.open(2000)
        @clients = []
        @run = true

        while @run do
          Thread.start(@server.accept) do |socket|
            client = Session.new(socket)
            Session.broadcast "Connection from #{client.socket.remote_address.ip_address}."
            while line = client.gets.chop
              case
              when line == "quit"
                client.close_connection
              when line == "shutdown"
                shutdown_server
              when line[0] == ":"
                get_value(line[1..-1], client)
              when line[0] == '"'
                send_message(line[1..-1], client)
              when line.split('=').length == 2
                set_value(line, client)
              else
                unknown_command(line, client)
              end
            end
          end
        end
      end

      private

      def unknown_command(line, client)
        puts "#{client.user.name} sent us: #{line}"
        client.puts "I don't understand?"
      end

      def send_message(message,client)
        Session.broadcast "#{client.user.name} says: #{message}"
      end

      def set_value(line, client)
        key, value = line.split('=')
        Session.broadcast "#{client.user.name} sets #{key} to #{value}."
        @redis.set key, value
      end

      def get_value(key, client)
        puts "#{client.user.name} gets #{key}."
        client.puts @redis.get(key)
      end

      def shutdown_server
        @run = false
        puts "Shutting down TCP Server..."
        Session.broadcast "Server is shutting down..."
        Session.clients.each {|client| client.close_connection}
        @server.close
      end

    end
  end
end
