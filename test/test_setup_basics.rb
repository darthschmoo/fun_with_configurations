require 'helper'

class TestSetupBasics < FunWith::Configurations::TestCase
  context "testing basics" do
    context "FunWith::Configurations module"
    should "respond to :configure" do
      assert FunWith::Configurations.respond_to?(:configure)
    end
  end
end