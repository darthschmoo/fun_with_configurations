require 'fun_with_files'
module FunWith
  module Configurations
  end
end

FunWith::Files::RootPath.rootify( FunWith::Configurations, __FILE__.fwf_filepath.dirname.up )

require_relative File.join( "fun_with", "configurations", "config" )
require_relative File.join( "fun_with", "configurations", "configurations" )
require_relative File.join( "fun_with", "configurations", "object" )
require_relative File.join( "fun_with", "configurations", "try_object" )

