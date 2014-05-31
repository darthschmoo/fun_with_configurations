module FunWith
  module Configurations
    class TryResult
      attr_accessor :config
      def initialize( config, success )
        @config = config
        @success = success
      end
      
      def success?
        @success
      end
    end
  end
end