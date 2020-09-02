# require 'rubygems'
# require 'bundler'
# require 'debugger'
# 
# begin
#   Bundler.setup(:default, :development)
# rescue Bundler::BundlerError => e
#   $stderr.puts e.message
#   $stderr.puts "Run `bundle install` to install missing gems"
#   exit e.status_code
# end
# require 'test/unit'
# require 'shoulda'
# 
# $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
# $LOAD_PATH.unshift(File.dirname(__FILE__))
require 'fun_with_testing'
require 'fun_with_configurations'

# class Test::Unit::TestCase
# end

class FunWith::Configurations::TestCase < FunWith::Testing::TestCase
  include FunWith::Configurations
  FWC = FunWith::Configurations
  
  def add_a_configuration_to( obj )
    FWC.configure( obj, FunWith::Configurations.root( "test", "data", "config.rb" ) )
  end
end