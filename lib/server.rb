require 'socket'
require 'pp'

module RubyMUSH
  class Server

    class << self

      def run
        @server = TCPServer.open(2000)
        @clients = []
        @stop = false

        server_boot_stats

        until @stop do
          Thread.start(@server.accept) do |socket|
            client = Session.new(socket)
            do_look(client)
            Session.broadcast "#{client.player.name} has connected."
            while command = extract_command(client.gets.chop)
              case
              when command.first == "quit"
                client.close_connection
              when command.first == "shutdown"
                shutdown_server
              when command.first == "look"
                do_look(client)
              when command.first == '"'
                send_message(command.last, client)
              when command.first == "go"
                do_go(command.last,client)
              else
                unknown_command(command, client)
              end
            end
          end
        end
      end

      private

      def do_go(direction, client)
        client.player.location.exits.each do |exit|
          if exit.directions.split(';').include? direction
            client.player.location = exit.destination
            client.puts "You go #{direction} to #{exit.destination.name}."
            do_look(client)
            return
          end
        end
        client.puts "You can't go that way."
      end

      def do_look(client)
        client.puts "#{client.player.location.name} (##{client.player.location.id})"
        client.puts client.player.location.description
        client.player.location.exits.each do |exit|
          client.puts "#{exit.name} (#{exit.directions})"
        end
      end

      def extract_command(input_line)
        if %w{"}.include? input_line[0]
          return [input_line[0], input_line[1..-1]]
        else
          return [input_line.split(' ').first, input_line.split(' ')[1..-1].join(' ')]
        end
      end

      def unknown_command(line, client)
        puts "#{client.player.name} (#{client.player.id}) sent unknown command: #{line}"
        client.puts "I don't understand?"
      end

      def send_message(message,client)
        Session.broadcast "#{client.player.name} says: #{message}"
      end

      def shutdown_server
        @stop = true
        puts "Shutting down TCP Server..."
        Session.broadcast "Server is shutting down..."
        Session.clients.each {|client| client.close_connection}
        @server.close
      end

      def server_boot_stats
        Kernel.puts "Booting RubyMUSH instance..."
        Kernel.puts "Server stats:"
        Kernel.puts "#{Room.all.count} rooms..."
        Kernel.puts "#{Exit.all.count} exits..."
        Kernel.puts "#{Item.all.count} items..."
        Kernel.puts "#{Player.all.count} players..."
        Kernel.puts "=============="
        Kernel.puts "Accepting connections on port 2000."
      end

    end
  end
end
