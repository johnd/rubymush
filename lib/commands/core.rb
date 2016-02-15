module RubyMUSH
  module Commands
    class CoreCommands < CommandBase

      def self.command_map
        { :quit => "close_connection",
          :shutdown => "shutdown_server",
          :look => "do_look",
          '"'.to_sym => "send_message",
          :go => "do_go" } 
      end

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

      def send_message(client, command)
        message = command.last
        Session.broadcast "#{client.player.name} says: #{message}"
      end

      def shutdown_server(client, command)
        RubyMUSH::Server.stop
        puts "Shutting down TCP Server..."
        Session.broadcast "Server is shutting down..."
        Session.clients.each {|client| client.close_connection}
        @server.close
      end
    end
  end
end
