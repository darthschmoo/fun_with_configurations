require 'fun_with_files'
require 'debugger'

module FunWith
  module Configurations
  end
end

FunWith::Files::RootPath.rootify( FunWith::Configurations, __FILE__.fwf_filepath.dirname.up )


FunWith::Configurations.root( "lib", "fun_with", "configurations" ).requir

