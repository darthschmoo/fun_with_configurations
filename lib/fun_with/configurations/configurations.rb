module FunWith
  module Configurations
    module Configurable
      def config=( config )
        @fwc_config = config
      end
    
      def config( &block )
        yield @fwc_config if block_given?
        @fwc_config
      end
    end
  end
end

