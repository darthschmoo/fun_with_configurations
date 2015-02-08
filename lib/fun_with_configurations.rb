require 'fun_with_gems'

FunWith::Gems.make_gem_fun( "FunWith::Configurations" )
FunWith::Configurations::Config.extend( FunWith::Configurations::ConfigAPI )
Object.send(:include, FunWith::Configurations::ObjectMethods)