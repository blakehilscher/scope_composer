module ScopeComposer
class Scope
  
  class << self
    
    def define_scope_composer( parent_class, scope_type )
      # define a class method for adding scopes to the composer
      scope_subclass = define_scope_subclass( parent_class, scope_type  )
      # eg. dataset_scope :limit
      parent_class.send(:define_singleton_method, "#{scope_type}_scope") do |*args|
        # act as getter if args are nil
        return scope_subclass if args.first.nil?
        # delegate the scope definition to the sub-class
        scope_subclass.define_scope(*args)
        scope_subclass.define_scope_delegate(parent_class, scope_type, *args)
      end
      parent_class.send(:define_singleton_method, "#{scope_type}_helper") do |*args|
        scope_subclass.define_helper(*args)
      end
    end
    
    def define_scope(*args)
      args[1].is_a?(Proc) ? define_proc_scope(*args) : define_simple_scopes(*args)
    end
    
    def define_helper(name, proc, *args)
      # ensure symbol
      name = name.to_sym
      # define method
      define_method(name) do |*args|
        # otherwise set the value
        instance_exec(*args, &proc)
      end
      # add to scope list
      helpers[name] = proc
    end
    
    def define_scope_delegate(parent_class, scope_type, *args)
      # options
      options = args.extract_options!
      scope_subclass = self
      # for each scope name
      args.each do |scope_name|
        # skip non text scopes
        next unless scope_name.is_a?(String) || scope_name.is_a?(Symbol)
        # add prefix if required
        method_name = scope_name
        method_name = "#{method_name}_#{scope_type}" if options[:prefix] == true
        # define method
        parent_class.send(:define_singleton_method, method_name) do |*args|
          # delegate the scope to an instance of this scope
          scope_subclass.new.send( scope_name, *args )
        end
      end
    end
    
    def scope_names
      @scope_names ||= scopes.keys
    end
    
    def helper_names
      @helper_names ||= helpers.keys
    end
    
    def scopes
      @scopes ||= {}
    end
    
    def helpers
      @helpers ||= {}
    end
    
    protected
    
    def define_scope_subclass(parent_class, scope_type)
      # the class name
      class_name = "#{scope_type.to_s.camelize}Scope"
      # define the class if it doesn't exist
      unless parent_class.const_defined?(class_name)
        # the new scope class inherits from Scope
        scope_class = Class.new(ScopeComposer::Scope)
        # the class is attached the parent class
        parent_class.const_set class_name, scope_class
      end
      # return the scope class
      "#{parent_class.name}::#{class_name}".constantize
    end
    
    def define_proc_scope(name, proc, *args)
      # ensure symbol
      name = name.to_sym
      # define method
      define_method(name) do |*args|
        # if no value is given, act as a getter and retrieve the value
        return read_scope_attribute(key) if args.compact.blank?
        # otherwise set the value
        instance_exec(*args, &proc)
        # and return self for chaining
        self
      end
      define_method("#{name}=") do |*args|
        self.send( name, *args )
      end
      # add to scope list
      scopes[name] = proc
    end
    
    def define_simple_scopes(*args)
      options = args.extract_options!
      args.each { |name| define_simple_scope(name, options) }
    end
    
    def define_simple_scope(name, options)
      # ensure symbol
      name = name.to_sym
      # define method
      define_method(name) do |*args|
        # without args return the value
        return read_scope_attribute(name) if args.compact.blank?
        # given args, set value
        self.send("#{name}=", args)
        # and return self for chaining
        return self
      end
      define_method("#{name}=") do |*args|
        write_scope_attribute(name, *args)
      end
      # add to scoping list
      scopes[name] = nil
    end
  
  end
  
  delegate :to_param, to: :attributes
  
  def read_scope_attribute(key)
    scope_attributes[key]
  end
  
  def write_scope_attribute(key, values)
    scope_attributes[key] = (values.count == 1) ? values.first : values
  end
  
  def assign_attributes(*attrs)
    attrs = attrs.extract_options!
    attrs.each do |key, value|
      self.send("#{key}=", value) if self.respond_to?("#{key}=")
    end
  end
  
  def where(*args)
    attrs = args.extract_options!
    attrs.symbolize_keys!
    self.attributes = attrs
    self
  end
  
  def attributes
    @attributes ||= {}
  end

  def attributes=(attrs)
    @attributes = self.attributes.merge(attrs)
  end
  
  def scope_attributes
    @scope_attributes ||= {}
  end
  
end
end
