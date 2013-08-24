module ScriptRunner

  module Commands

    class Ping
      def initialize
      end

      def run(msg, options = { :reverse => false })
        if options[:reverse]
          msg.reverse
        else
          msg
        end
      end
    end
  end
end

