require 'socket'
require 'pp'
require_relative 'commands/all'

module RubyMUSH
  class Server

    class << self

      def stop
        @@stop = true
      end

      def run
        @server = TCPServer.open(2000)
        @clients = []
        @@stop = false
        #@commands = { :quit => ["RubyMUSH::Commands::CoreCommands", "close_connection"],
        #              :shutdown => ["RubyMUSH::Commands::CoreCommands", "shutdown_server"],
        #              :look => ["RubyMUSH::Commands::CoreCommands", "do_look"],
        #              '"'.to_sym => ["RubyMUSH::Commands::CoreCommands", "send_message"],
        #              :go => ["RubyMUSH::Commands::CoreCommands", "do_go"]}

        @commands = RubyMUSH::Commands::CommandBase.collected_commands
        Kernel.puts @commands

        server_boot_stats

        until @@stop do
          Thread.start(@server.accept) do |socket|
            client = Session.new(socket)
            Commands::CoreCommands.new.do_look(client,nil)
            Session.broadcast "#{client.player.name} has connected."
            while command = extract_command(client.gets.chop)
              call_class, call_method = @commands[command.first.to_sym]
              Kernel.puts "Class: #{call_class}, Method: #{call_method}"
              if call_class
                call_class.new.method(call_method).call(client, command)
              else
                unknown_command(client, command)
              end
            end
          end
        end
      end

      private

      def unknown_command(client, command)
        puts "#{client.player.name} (#{client.player.id}) sent unknown command: #{command}"
        client.puts "I don't understand?"
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
