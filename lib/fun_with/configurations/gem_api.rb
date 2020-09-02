module FunWith
  module Configurations
    module GemAPI
      # FunWith::Gems.configure( <object_to_configure>, "<YAML_TEXT>" )
      # FunWith::Gems.configure( <object_to_configure>, "<FILEPATH_AS_STRING" )
      def configure( object, config = nil, &block )
        if block_given?
          object.install_fwc_config( config, &block )          
        else
          case configuration_argument_type?( config )
          when :filepath
            object.install_fwc_config_from_file( config )
          when :yaml
            object.install_fwc_config_from_yaml( config )
          when :hash
            object.install_fwc_config_from_hash( config )
          when :nil
            object.install_fwc_config_from_hash( {} )
          end
        end
                
        object
      end
      
      # 
      protected
      def configuration_argument_type?( arg )
        case arg
        when FunWith::Files::FilePath
          :filepath
        when String
          if arg.fwf_filepath.exist?
            :filepath
          elsif arg =~ /\n/              # seems not-ideal
            :yaml
          else
            :filepath
          end
        when Hash
          :hash
        when NilClass
          :nil
        else
          warn "#{__FILE__}:#{__LINE__} unknown configuration type #{arg.class}"
        end
      end
    end
  end
end