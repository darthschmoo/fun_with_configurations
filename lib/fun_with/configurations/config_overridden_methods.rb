module FunWith
  module Configurations
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
  end
end
