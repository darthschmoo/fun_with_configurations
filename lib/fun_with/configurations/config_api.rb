module FunWith
  module Configurations
    # methods on the FunWith::Configurations::Config class itself.
    module ConfigAPI
      def key_check( sym )
        @reserved_symbols ||= Config.instance_methods - self.fwc_overridden_methods
        
        raise KeyError.new("#{sym} is not a symbol") unless sym.is_a?(Symbol)
        raise KeyError.new("#{sym} is reserved for use by Hash") if @reserved_symbols.include?( sym )
      end
      
      
      def from_file( file )
        file = file.fwf_filepath

        case file.ext
        when "rb"
          self.new do
            eval( file.read )
          end
        when "yml", "yaml"
          self.from_yaml( file.read )
        else
          warn( "Unknown filetype: #{file.ext} (file:#{file}}). Returning empty config." )
          self.new
        end
      end
      
      def from_hash( hash )
        (config = self.new).tap do
          for k, v in hash
            config.send( k, v.is_a?( Hash ) ? self.from_hash( v ) : v )
          end
        end
        config
      end
      
      def from_yaml( yaml_string )
        self.from_hash( Psych.load( yaml_string ) )
      end
      
      def fwc_overridden_methods
        ConfigOverriddenMethods.instance_methods.grep( /[^=]$/ )
      end
    end
  end
end