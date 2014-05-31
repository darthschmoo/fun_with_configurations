require 'helper'

module FunWith
  module Configurations
    class TestClass
      attr_accessor :name, :rank, :serial_number
      
      def initialize( config = nil)
        unless config.nil?
          self.install_fwc_config( config )
          self.config.set.subset.subsubset.fwc_assign!
        end
      end
    end
  end
end


class TestFunWithConfigurations < FunWith::Configurations::TestCase
  context "testing the block form for assignments" do
    setup do
      @config = FunWith::Configurations::Config.new do
        set do
          subset do
            subsubset do
              name "Leonard Morgan"
              rank "Lieutenant"
              serial_number "513-555-1024"
            end
          end
        end
      end
      
      assert_equal "Leonard Morgan", @config.set.subset.subsubset.name
    end
      
    should "execute fwc_assign! properly" do
      obj = FunWith::Configurations::TestClass.new( @config )
      
      assert_equal "Leonard Morgan", obj.name
      assert_equal "Lieutenant", obj.rank
      assert_equal "513-555-1024", obj.serial_number
    end
    
    should "run a config block" do
      obj = FunWith::Configurations::TestClass.new( nil )
      
      @config.set.subset.subsubset.fwc do |c|
        obj.name = c.name
        obj.rank = c.rank
        obj.serial_number = c.serial_number
      end
      
      assert_equal "Leonard Morgan", obj.name
      assert_equal "Lieutenant", obj.rank
      assert_equal "513-555-1024", obj.serial_number
    end
  end
end