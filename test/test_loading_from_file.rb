require 'helper'

class FunWith::Configurations::ServerManager
end

class TestLoadingFromFile < FunWith::Configurations::TestCase
  should "load from a .rb file" do
    @srvman.install_fwc_config_from_file( @config_root.join("config.rb") )
    assert @srvman.respond_to?(:config)
    assert_equal "192.168.0.27", @srvman.config.servers.squishy_host.ip
  end
  
  should "load from a .yaml file" do
    @srvman.install_fwc_config_from_file( @config_root.join("config.yaml") )
    assert_equal "not bloody likely", @srvman.config.servers.puppymonster.services.twitter
  end

  should "load from a .yml file" do
    @srvman.install_fwc_config_from_file( @config_root.join("config.yml") )
    assert_equal "no", @srvman.config.servers.puppymonster.services.twitter
  end
  
  def setup
    @srvman = FunWith::Configurations::ServerManager.new
    assert !( @srvman.respond_to?(:config) )
    @config_root = FunWith::Configurations.root( "test", "data" )
  end
end


