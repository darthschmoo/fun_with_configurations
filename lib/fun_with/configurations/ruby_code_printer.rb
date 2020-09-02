module FunWith
  module Configurations
    class RubyCodePrinter
      def to_ruby_code( config, opts = {} )
        @previous_action = :initial
        
        indent = opts.fetch(:indent){ 0 }
        
        "".tap do |code|
          longest_key_length = config.fwc_keys.map(&:length).max
          
          for k, v in config
            code << generate_comments( config, k, indent )

            if v.is_a?( Config )
              code << generate_subconfiguration( k, v, indent )
            else
              code << generate_configuration_setting( pad( longest_key_length, k ), v, indent )
            end
          end
        end
      end
      
      protected
      def generate_comments( config, key, indent )
        "".tap do |code|
          puts config.fwc_comments_hash.inspect
          if config.fwc_comments_hash[key].fwf_present?
            code << whitespace( :comment )
            for line in config.fwc_comments_hash[key]
              code << indentation( indent ) + "fwc_comment #{line.inspect}\n"
            end
            @previous_action = :comment
          end
        end
      end
      
      def generate_subconfiguration( k, v, indent )
        "".tap do |code|
          code << whitespace( :subconfig )
          code << indentation( indent ) + "#{k} do\n"
          code << RubyCodePrinter.new.to_ruby_code( v, :indent => indent + 1 )
          code << indentation( indent ) + "end\n"
          
          @previous_action = :subconfig
        end
      end
      
      def generate_configuration_setting( k, v, indent )
        "".tap do |code|
          code << whitespace( :setting )
          code << indentation( indent ) + k + v.inspect + "\n"
          @previous_action = :setting
        end
      end
      
      def indentation( i )
        "  " * i
      end
      
      def pad( len, k )
        "#{k} " + " " * (len - k.length) 
      end
      
      def whitespace( current_action )
        case @previous_action
        when :setting
          return "\n" if current_action == :subconfig
        when :subconfig
          return "\n"
        when :comment
          
        end
        
        ""
      end
    end
  end
end
