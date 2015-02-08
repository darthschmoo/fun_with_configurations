module FunWith
  module Configurations
    module ObjectMethods
      def install_fwc_config( config = nil, &block )
        extend FunWith::Configurations::Configurable
        self.config = config || FunWith::Configurations::Config.new( &block )
        self.config.fwc_configured_object = self
        self.config
      end
  
      def install_fwc_config_from_file( file )
        config = FunWith::Configurations::Config.from_file( file )
        self.install_fwc_config( config )
        self.fwc_configuration_file = file
        self.config
      end
  
      def install_fwc_config_from_hash( hash )
        config = FunWith::Configurations::Config.from_hash( hash )
        self.install_fwc_config( config )
        self.config
      end

      def install_fwc_config_from_yaml( yaml_string )
        config = Config.from_yaml( yaml_string )
        self.install_fwc_config( config )
        self.config
      end
    end
  end
end

