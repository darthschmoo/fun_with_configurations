# encoding: utf-8

# encoding: utf-8
require 'fun_with_gems'
require_relative File.join( "lib", "fun_with_configurations" )


self.extend( FunWith::Gems::Rakefile )

rakefile_setup( FunWith::Configurations )

gem_specification do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "fun_with_configurations"
  gem.homepage = "http://github.com/darthschmoo/fun_with_configurations"
  gem.license = "MIT"
  gem.summary = "A quick and feisty configuration creator (e.g. MyClass.config)"
  gem.description = <<-DESC
Attach a configuration object to any object or class with code like this:
   spy.install_fwc_config do
     spy_id "74 Baker"
DESC
  gem.email = "keeputahweird@gmail.com"
  gem.authors = ["Bryce Anderson"]
  # dependencies defined in Gemfile
  add_specification_files( gem, :default )
end

setup_gem_boilerplate
