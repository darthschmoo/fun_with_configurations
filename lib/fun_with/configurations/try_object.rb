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
    
    class TryObject
      # takes a Config object
      def initialize( config )
        @config  = config
        @success = true
        @leaf    = false
      end
      
      def method_missing( method, *args )
        follow_config_method_chain( method )
      end

      def [] method_key
        follow_config_method_chain( method_key.to_sym )
      end
      
      def follow_config_method_chain( method )
        if @success == true
          if @config.is_a?(Config) && @config.has_key?(method)
            @config = @config[method]
            unless @config.is_a?(Config)
              @leaf = true
            end
          elsif @leaf
            @leaf = false   # declare unsuccessful on next call.
          else
            @success = false
          end
        end
        
        self
      end
      
      def config_method_chain_result( *keys )
        keys = keys.flatten
        
        if success?
          keys.each do |k|
            follow_config_method_chain(k)
          end
        end
        
        TryResult.new( @config, success? )
      end
      
      def success?
        @success
      end
    end
  end
end