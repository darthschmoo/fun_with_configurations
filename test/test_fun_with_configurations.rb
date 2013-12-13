require 'helper'

class TestFunWithConfigurations < FunWith::Configurations::TestCase
  should "configurize a class" do
    o = Object.new
    o.install_fwc_config do
      malaprop :sym
      blocky do
        fish :guts
      end
    end
    
    assert_equal :sym, o.config.malaprop
    assert_equal :guts, o.config.blocky.fish
  end
  
  context "testing a configurized class" do
    setup do
      @obj = Object.new
      @obj.install_fwc_config do
        a :b
        b :c
        c do
          d :e
          e :f
          f :g
        end
        
        s do
          t do
            u do
              v do
                w :x
              end
            end
          end
        end
      end
    end
    
    should "verify existing configuration" do
      assert_equal :b, @obj.config.a
      assert_equal :g, @obj.config.c.f
    end
    
    should "blockily extend configuration" do
      @obj.config.c.g do
        h :i
        i :j
        j do
          k :l
          m do
            n :o
          end
        end
      end
      
      assert_equal :i, @obj.config.c.g.h
      assert_equal :o, @obj.config.c.g.j.m.n
    end
    
    should "blockily extend by overwriting existing keys" do
      # replace c?  Additive 
      @obj.config.c do
        q :r
      end
      
      assert_equal :b, @obj.config.a
      assert_equal :g, @obj.config.c.f
      assert_equal :r, @obj.config.c.q      
    end
    
    should "handle equal-style assignment niftily" do
      @obj.config.c = :d
      assert_equal :d, @obj.config[:c]
      assert_equal nil, @obj.config[:c=]
    end
    
    should "gripe when given a hash" do
      assert defined?( FunWith::Configurations::KeyError )
      assert_raises FunWith::Configurations::KeyError do |err|
        @obj.config[{c: "hey"}]
      end
    end
    
    should "gripe when given a reserved method as a key" do
      assert defined?( FunWith::Configurations::KeyError )
      assert_raises FunWith::Configurations::KeyError do |err|
        @obj.config[:clone] = ["22461", "80129"]
      end  
      
      assert_raises FunWith::Configurations::KeyError do |err|
        @obj.config.clone = ["22461", "80129"]
      end
    end
    
    should "pass tests for try() function" do
      assert_equal true,  @obj.config.try.a.success?
      assert_equal true,  @obj.config.try.a.b.success?
      assert_equal false,  @obj.config.try.a.b.c.success?
      assert_equal false, @obj.config.try.a.b.c.d.e.f.g.h.success?
      assert_equal true,  @obj.config.try.c.d.success?
      assert_equal true,  @obj.config.try[:c]["d"].success?     # alternate traversal mechanism
    end
    
    should "have parents" do
      assert_kind_of FunWith::Configurations::Config, @obj.config.c.instance_variable_get(:@parent)
      assert_kind_of FunWith::Configurations::Config, @obj.config.s.t.u.instance_variable_get(:@parent).instance_variable_get(:@parent)
    end
    
    should "promote subconfiguration" do
      assert_equal :x, @obj.config.s.t.u.v.w
      @obj.config.s.t.u.v.promote_configuration(:w)
      assert_equal :x, @obj.config.s.t.u.v
    end

    should "promote sub-subconfiguration" do
      assert_equal :x, @obj.config.s.t.u.v.w
      @obj.config.s.t.u.promote_configuration(:v,:w)
      assert_equal :x, @obj.config.s.t.u
    end
  end
  
  should "successfully create configuration manually" do
    @obj = Object.new
    @obj.extend( FunWith::Configurations::Configurable )
    @obj.config = FunWith::Configurations::Config.new( nil ) do
      betelgeuse "red"
      rigel "blue-white"
    end
    
    assert_equal "blue-white", @obj.config.rigel
  end
  
  context "testing overridden methods|" do
    setup do
      @obj = Object.new
      @obj.install_fwc_config do
        malaprop :sym
        blocky do
          fish :guts
          test :has_caused_problems
        end
      end
    end
    
    should "override test" do
      assert @obj.config.blocky.respond_to?(:test)
      assert_equal :has_caused_problems, @obj.config.blocky.test 
    end
  end
  
  should "hold multiple arguments as arrays" do
    @obj = Object.new
    @obj.install_fwc_config do
      my_array 1,2,3,nil,5
      my_array2 [1,2,3,nil,5]
    end
    
    assert_equal @obj.config.my_array, @obj.config.my_array2
  end
  
  context "testing from_hash" do
    setup do
      @obj = Object.new
      @obj.install_fwc_config_from_hash({
        :calista => "Flockhart",
        :jude    => "Law"
      })
    
      @obj2 = Object.new
      @obj2.install_fwc_config_from_hash({
        :a => {
          :b => {
            :c => {
              :d => "e"
            }
          }
        }
      })
      
      @obj3 = Object.new
      yaml = FunWith::Configurations.root("test", "data", "config.yml").read
      @obj3.install_fwc_config_from_yaml( yaml )
    end
    
    should "have successfully created configs" do
      assert_equal "Law", @obj.config.jude
      assert_equal "e", @obj2.config.a.b.c.d
      assert_equal "definitely", @obj3.config.servers.puppymonster.services.oauth
    end
  end
  
  context "testing code writer" do
    setup do
      @obj = Object.new
      
      @obj.install_fwc_config do
        scream 1,2,3,4,5
        yell   [1,2,3,4,5]
        whisper do
          secret1 "80888"
          secret2 "12345"
          secret3 "99999"    # the most secret combination, cuz it's the last one anyone tries
        end
      end
    end
    
    should "do stuff" do
      assert_match /\[1, 2, 3, 4, 5\]/, @obj.config.to_ruby_code
    end
  end
end
