require 'helper'

class TestSetupBasics < FunWith::Configurations::TestCase
  context "testing basics" do
    context "FunWith::Configurations module" do
      should "respond to :configure" do
        assert FunWith::Configurations.respond_to?(:configure)
      end
    end
  end
end