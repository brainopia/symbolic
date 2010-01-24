module Symbolic
=begin
This class is used to create symbolic variables.
Symbolic variables presented by name and value.
Name is neccessary for printing meaningful symbolic expressions.
Value is neccesary for calculation of symbolic expressions.
If value isn't set for variable, but there is an associated proc, then value is taken from evaluating the proc.
=end
  class Variable
    include Symbolic
    attr_accessor :name, :proc, :value

    # Create a new Symbolic::Variable, with optional name, value and proc
    def initialize(*args, &proc) # () or (name) or (value) or (name, value) => not (value, name)
      args.unshift nil if Numeric === args.first
      (@name, @value), @proc = args, proc
    end

    alias :get_value :value
    def value
      get_value || @proc && @proc.call.value
    end

    def to_s
      Printer.variable(self)
    end

    def variables
      [self]
    end
  end
end