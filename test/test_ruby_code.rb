require 'helper'

class TestRubyCode < FunWith::Configurations::TestCase
  context "testing ruby code generation" do
    setup do
      @obj = add_a_configuration_to( Object.new )
      
    end
    
    should "print some code" do
      puts @obj.config.to_ruby_code
    end
  end
end