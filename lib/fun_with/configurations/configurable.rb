# methods available to a configuration-having object.

module FunWith
  module Configurations
    module Configurable
      # Replaces existing configuration
      def config=( config )
        @fwc_config = config
      end
    
      def config( &block )
        yield @fwc_config if block_given?
        @fwc_config
      end
      
      def fwc_configuration_file
        @fwc_configuration_file
      end
      
      def fwc_configuration_file=( file )
        @fwc_configuration_file = file.fwf_filepath
      end
    end
  end
end

