module ScopeComposer
  module Model
  
    extend ActiveSupport::Concern
  
    module ClassMethods
      
      def has_scope_composer
        ScopeComposer::Scope.define_scope_composer( self, :scope )
        # alias_method scope and scope_helper
        self.define_singleton_method(:scope){|*args| scope_scope(*args) }
      end
      
      def scope_composer_for(*args)
        # each scope_composer arg is a new type of scope
        args.each do |scope_type|
          # define a class method for adding scopes to the composer
          ScopeComposer::Scope.define_scope_composer( self, scope_type )
        end
      end
     
    end
  
  end
end