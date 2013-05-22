module FunWith
  module Configurations
    class KeyError < Exception
    end
    
    class ChainError < Exception
    end
    
    module ConfigOverriddenMethods
      def self.override_method( sym )
        eval <<-EOS
          def #{sym}( *args, &block )
            self.method_missing(:sym, *args, &block)
          end
          
          def #{sym}=( *args, &block )
            self.method_missing( :#{sym}, *args, &block )
          end
        EOS
      end
      
      for sym in [:test]
        override_method( sym )
      end
    end
    
    class Config
      include ConfigOverriddenMethods
      
      def initialize( key_to_self = nil, parent = nil, &block )
        @key_to_self = key_to_self
        @parent      = parent
        @config_vars = {}
        self.instance_exec( &block ) if block_given?
      end
    
      def method_missing( method, *args, &block )
        method = method.to_s.gsub( /=$/, '' ).to_sym
        
        if block_given?
          self[method] = Config.new(method, self) unless self[method].is_a?(Config)
          self[method].instance_exec( &block )
        elsif args.length == 1
          self[method] = args.first
        elsif args.length > 1
          self[method] = args
        else
          self[method]   
        end
      end
      
      def []( sym )
        sym = sym.to_sym if sym.is_a?(String)
        self.class.key_check( sym )
        @config_vars[ sym ]
      end
      
      def []=( sym, val )
        sym = sym.to_sym if sym.is_a?(String)
        self.class.key_check( sym )
        @config_vars[ sym ] = val
      end
      
      # Say you had a configuration that had multiple entries, and you wanted to select from
      # among them at runtime.  Example:
      # config:
      #   important_folder:
      #     development: "/this/directory",
      #     test:        "/that/directory",
      #     production:  "~/another/directory"
      #
      # You could do config.important_folder[environment] every time you want to access that setting.
      # Or you can do config.important_folder.promote_configuration(:development) and have the 
      # development subconfiguration replace the important_folder: configuration
      # 
      # You can promote a sub-sub-sub-config by sending an array of symbols.  But I hope it
      # never comes to that.
      def promote_configuration( *keys )
        replace_with = self.try.config_method_chain_result( keys )
        if replace_with.success?
          @parent[@key_to_self] = replace_with.config
        else
          raise ChainError.new( "config failed to promote_configuration #{keys.inspect}" )
        end
      end
      
      def self.key_check( sym )
        @reserved_symbols ||= Config.instance_methods - self.fwc_overridden_methods
        
        raise KeyError.new("#{sym} is not a symbol") unless sym.is_a?(Symbol)
        raise KeyError.new("#{sym} is reserved for use by Hash") if @reserved_symbols.include?( sym )
      end
      
      def try( *keys )
        (t = TryObject.new( self )).tap do
          for key in keys
            t[key]
          end
        end
      end
      
      def to_ruby_code( indent = 0 )
        (code = "").tap do
          if indent == 0
            code << "FunWith::Configurations::Config.new do\n"
            code << self.to_ruby_code( 2 )
            code << "end\n"
          else
            for k, v in @config_vars
              if v.is_a?( Config )
                code << (" " * indent) + "#{k} do\n"
                code << v.to_ruby_code( indent + 2 )
                code << (" " * indent) + "end\n"
              else
                code << (" " * indent) + "#{k} #{v.inspect}\n"
              end
            end
          end
        end
      end
      
      def each( *args, &block )
        @config_vars.each( *args, &block )
      end
      
      def to_s( style = :hash )
        case style
        when :hash
          self.to_hash.inspect
        when :ruby
          self.to_ruby_code
        else
          super
        end
      end
      
      def to_hash
        (hash = {}).tap do
          for k, v in @config_vars
            hash[k] = v.is_a?(Config) ? v.to_hash : v
          end
        end
      end
      
      def self.from_hash( hash )
        (config = self.new).tap do
          for k, v in hash
            config.send( k, v.is_a?( Hash ) ? self.from_hash( v ) : v )
          end
        end
        config
      end
      
      def self.fwc_overridden_methods
        ConfigOverriddenMethods.instance_methods.grep( /[^=]$/ )
      end
      
      def fwc_overridden_methods
        self.class.fwc_overridden_methods
      end
    end
  end
end