module FunWith
  module Configurations
    class Config
      include ConfigOverriddenMethods
      
      def initialize( key_to_self = nil, parent = nil, &block )
        @key_to_self = key_to_self
        @parent      = parent
        @config_vars = {}
        
        @comment_buffer = []     # in lieu of actual comments, type ! "key to send with each call to the Mailchimp API" )
        @comments       = {}
        
        self.instance_exec( &block ) if block_given?
      end
    
      def method_missing( method, *args, &block )
        method = method.to_s.gsub( /=$/, '' ).to_sym
        
        if block_given? || args.length > 0
          @comments[method] = @comment_buffer
          @comment_buffer   = []
        end
                
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
      
      def try( *keys )
        (t = TryObject.new( self )).tap do
          for key in keys
            t[key]
          end
        end
      end
      
      def to_ruby_code
        FunWith::Configurations::RubyCodePrinter.new.to_ruby_code( self )
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
        when :yaml
          Psych.dump( self.to_hash )
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
      
      def fwc_overridden_methods
        self.class.fwc_overridden_methods
      end
      
      # Assigns the topmost set of configuration symbols as instance variables.
      # Translates any subconfigurations into a hash.
      # 
      # Example:
      #
      # config.set.subset.subsubset.fwc_assign!( obj )
      # 
      # Say that the referenced config had keys :name, :height, :gravatar, :public_key,
      # then the object would be assigned the corresponding instance_vars, @name, @height, etc.
      def fwc_assign!( obj = self.fwc_configured_object )
        for k, v in self
          obj.instance_variable_set( "@#{k}", v.is_a?( Config ) ? v.to_hash : v )
        end
        
        obj
      end
      
      # returns the topmost configuration, obviously
      def fwc_root
        root = self
        
        while true
          if root.fwc_parent.is_a?(Config)
            root = root.fwc_parent
          else
            return root
          end
        end
      end
      
      def fwc_root?
        self == self.fwc_root
      end
      
      def fwc_parent
        @parent
      end
      
      # Every subtree / subconfig in the config hierarchy will share the same configured object.
      def fwc_configured_object
        if self.fwc_root?
          @configured_object
        else
          self.fwc_root.fwc_configured_object
        end
      end
      
      # used for assigning the configured
      def fwc_configured_object=( obj )
        if self.fwc_root?
          @configured_object = obj
        else
          self.fwc_root.fwc_configured_object = obj
        end
      end
      
      
      
      # Useful when assigning selective settings from a config tree.  Example:
      #
      # RailsSite.config.constant_contact.fwc do |config|
      #   @key      = config.oauth.key
      #   @secret   = config.oauth.secret
      #   @redir    = config.oauth.redirect_url
      #   @user     = config.user
      #   @password = config.password
      # end
      #     
      def fwc( &block )
        yield self if block_given?
        self
      end
      
      def fwc_keys
        @config_vars.keys
      end
      
      
      def fwc_save( file = nil )
        raise "NOT TESTED!"
        
        root = self.fwc_root
        file = (file || root.fwc_configuration_file).fwf_filepath
        
        file.write( root.to_s )
      end
      
      def fwc_comment( str )
        @comment_buffer << str
      end
      
      def fwc_comments_hash
        @comments
      end
      
      
      # Overlay a config atop another, overwriting existing values with
      # new values when there's a conflict.  Good for making defaults
      # and overrides.
      #
      # default_settings do
      #   dark_mode :on
      #   theme     :gravity
      #   privacy do
      #     default_post_setting :public
      #   end
      # end
      #
      # user_settings do
      #   dark_mode :off
      #   privacy do
      #     default_post_setting :friends
      #   end
      # end
      #
      # settings = default_settings + user_settings
      #
      # 
      
      def +( rhs )
        combined = self.class.new
        
        for key in (self.fwc_keys + rhs.fwc_keys).uniq
          if self.fwc_keys.include?( key ) && rhs.fwc_keys.include?( key )
            self_val = self[key]
            rhs_val = rhs[key]
            
            if self_val.is_a?( self.class ) && rhs_val.is_a?( self.class )
              combined[key] = self_val + rhs_val
            else
              combined[key] = rhs_val     # 
            end
          else
            combined[key] = (self[key] || rhs[key]).clone
          end
        end
        
        combined
      end
    end
  end
end