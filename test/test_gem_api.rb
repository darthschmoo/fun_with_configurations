require 'helper'

class TestGemAPI < FunWith::Configurations::TestCase
  context "testing FunWith::Configurations.<class_methods>" do
    setup do
      @fwc = FunWith::Configurations
    end
    
    should "have API functions available" do
      assert @fwc.is_fun_gem?
      assert_respond_to @fwc, :configure
    end
    
    context "configure()" do
      should "work when given a block" do
        o = @fwc.configure( Object.new ) do |c|
          var0 "hello"
          var1 "world"
          var2 do
            var3 "fizz"
            var4 "buzz"
          end
        end
        
        assert_equal "hello", o.config.var0
        assert_equal "world", o.config.var1
        assert_equal "fizz", o.config.var2.var3
      end
      
      should "work when given an empty hash" do
        o = @fwc.configure( Object.new, {} )
        assert_respond_to o, :config
        assert_kind_of FunWith::Configurations::Config, o.config
        assert_nil o.config.bleak
        assert_nil o.config.thingy
        assert_empty o.config.to_hash
      end
      
      should "work when given a file (string)" do
        o = @fwc.configure( Object.new, "test/data/config.yaml" )
      end
    end
  end
end
