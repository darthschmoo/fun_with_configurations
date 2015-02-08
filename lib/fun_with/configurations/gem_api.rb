module FunWith
  module Configurations
    module GemAPI
      def configure( object, config = nil, &block )
        if block_given?
          object.install_fwc_config( config, &block )          
        else
          case config
          when String
            case yaml_or_filepath?( config )
            when :filepath
              object.install_fwc_config_from_file( config )
            when :yaml
              object.install_fwc_config_from_yaml( config )
            end
          when Pathname, FunWith::Files::FilePath
            object.install_fwc_config_from_file( config )
          when Hash, NilClass
          end
        end
      end
      
      # 
      protected
      def configuration_argument_type?( arg )
        case arg
        when String
          if str.fwf_filepath.exist?
            :filepath
          elsif str =~ /\n/
            :yaml
          else
            :filepath
          end
        when Hash
          :hash
        end
      end
    end
  end
end