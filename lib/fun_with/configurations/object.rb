class Object
  def install_fwc_config( config = nil, &block )
    extend FunWith::Configurations::Configurable
    self.config = config || FunWith::Configurations::Config.new( nil, &block )
    self.config
  end
  
  def install_fwc_config_from_file( file )
    file = file.fwf_filepath
    
    case file.ext
    when "rb"
      self.install_fwc_config do
        eval( file.read )
      end
    when "yml", "yaml"
      self.install_fwc_config_from_yaml( file.read )
    end
    
    self.fwc_configuration_file = file
  end
  
  def install_fwc_config_from_hash( hash )
    install_fwc_config( FunWith::Configurations::Config.from_hash( hash ) )
  end

  def install_fwc_config_from_yaml( yaml_string )
    install_fwc_config_from_hash( YAML.load( yaml_string ) )
  end
end

