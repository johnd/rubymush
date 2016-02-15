module RubyMUSH
  module Commands
    class CommandBase
     class << self

      def collected_commands
        commands = {}
        @@classes.each do |k|
          k.command_map.each do |cmd,meth|
            commands[cmd] = [k,meth]
          end
        end
        commands
      end

      def inherited(command_class)
        @@classes ||=[]
        @@classes << command_class
      end
     end
    end
  end
end
