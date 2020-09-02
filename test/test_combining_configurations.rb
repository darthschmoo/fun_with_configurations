require 'helper'

class TestCombiningConfigurations < FunWith::Configurations::TestCase
  context "given two configurations" do
    setup do
      @config0 = Config.new do
        employees do
          emily do
            name "Emily Scoutmaggle"
            address do
              street "7312 Bunderbuss Lane"
              city   "Beauchamp"
              state  "UT"
              zip    "84001"
            end
            
            workstation 7512
          end
        end
      end
      
      @config1 = Config.new do
        employees do
          brett do
            name "Brett Bretterson"
            address do
              street "1132 Buckner Street"
              city   "Olympia"
              state  "WA"
              zip    "33404"
            end
    
            workstation 9912
          end
          
          emily do
            phone "(212) 555-1212"
            
            address do
              zip "84002"
            end
          end
        end
      end
    end
    
    should "combine them into a third" do
      c3 = @config0 + @config1
      
      employee_keys = c3.employees.fwc_keys
      assert_includes employee_keys, :brett
      assert_includes employee_keys, :emily
      assert_equal "(212) 555-1212", c3.employees.emily.phone
      assert_equal "Olympia", c3.employees.brett.address.city
      assert_equal "84002", c3.employees.emily.address.zip
    end
  end
  
  context "given three sets of settings" do
    setup do
      @system_settings = Config.new do
        ui do
          resolution "standard"
          xmode      "compatibility"
          control_pane :top
        end
        
        key_layout do
          hotkeys do
            forward    :w
            turn_left  :a
            backward   :s
            turn_right :d
            fire       :space
          end
        end
      end
      
      @user_settings = Config.new do
        ui do
          resolution "high"
        end
      end
      
      @session_settings = Config.new do
        ui do
          xmode "plaid"
        end
        
        key_layout do
          forward    :"8"
          turn_left  :"4"
          backward   :"2"
          turn_right :"6"
          fire       :"5"          
        end
      end
    end
    
    should "create settings configurations" do
      assert_includes @user_settings.fwc_keys, :ui
      assert_includes @user_settings.ui.fwc_keys, :resolution
    end
    
    should "override defaults" do
      settings = @system_settings + @user_settings + @session_settings
      
      assert_equal "high", settings.ui.resolution
      
      assert_equal :"5", settings.key_layout.fire
    end
  end
end