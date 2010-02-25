module Symbolic
=begin
This class is used to create symbolic variables.
Symbolic variables presented by name and value.
Name is neccessary for printing meaningful symbolic expressions.
Value is neccesary for calculation of symbolic expressions.
If value isn't set for variable, but there is an associated proc, then value is taken from evaluating the proc.
=end
  class Variable < Abelian
    include Operators
    attr_accessor :name, :proc
    attr_writer :value

    # Create a new Symbolic::Variable, with optional name, value and proc
    def initialize(options={}, &proc)
      (@name, @value), @proc = options.values_at(:name, :value), proc
      @name = @name.to_s if @name
      super(self)
    end

    def value
      @value || @proc && @proc.call.value
    end
    
    def to_s
      "#{name || :unnamed_variable}"
    end
    
    def == object
      self.value == object.value rescue false
    end

    def variables
      [self]
    end
  end
end