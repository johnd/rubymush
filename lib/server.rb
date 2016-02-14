require 'socket'
require 'pp'

module RubyMUSH
  class Server

    class << self

      def run
        @server = TCPServer.open(2000)
        @clients = []
        @stop = false
        @commands = { :quit => "close_connection",
                      :shutdown => "shutdown_server",
                      :look => "do_look",
                      '"'.to_sym => "send_message",
                      :go => "do_go"}

        server_boot_stats

        until @stop do
          Thread.start(@server.accept) do |socket|
            client = Session.new(socket)
            do_look(client,nil)
            Session.broadcast "#{client.player.name} has connected."
            while command = extract_command(client.gets.chop)
              call_method = @commands[command.first.to_sym]
              if call_method
                method(call_method).call(client, command)
              else
                unknown_command(client, command)
              end
            end
          end
        end
      end

      private

      def close_connection(client, command)
        client.close_connection
      end

      def do_go(client, command)
        direction = command.last
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

      def do_look(client, command)
        client.puts "#{client.player.location.name} (##{client.player.location.id})"
        client.puts client.player.location.description
        client.player.location.exits.each do |exit|
          client.puts "#{exit.name} (#{exit.directions})"
        end
      end

      def unknown_command(client, command)
        puts "#{client.player.name} (#{client.player.id}) sent unknown command: #{command}"
        client.puts "I don't understand?"
      end

      def send_message(client, command)
        message = command.last
        Session.broadcast "#{client.player.name} says: #{message}"
      end

      def shutdown_server(client, command)
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

      def extract_command(input_line)
        if %w{"}.include? input_line[0]
          return [input_line[0], input_line[1..-1]]
        else
          return [input_line.split(' ').first, input_line.split(' ')[1..-1].join(' ')]
        end
      end

    end
  end
end
