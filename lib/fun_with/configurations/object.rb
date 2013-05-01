class Object
  def install_fwc_config( config = nil, &block )
    extend FunWith::Configurations::Configurable
    self.config = config || FunWith::Configurations::Config.new( nil, &block )
    self.config
  end
  
  def install_fwc_config_from_file( filename )
    install_fwc_config( eval( File.read( filename ) ) )  # TODO: Has to be a better way than eval().  Dangerous.
  end
  
  def install_fwc_config_from_hash( hash )
    install_fwc_config( FunWith::Configurations::Config.from_hash( hash ) )
  end

  def install_fwc_config_from_yaml( yaml_string )
    install_fwc_config_from_hash( YAML.load( yaml_string ) )
  end
end