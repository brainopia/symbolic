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
    def initialize(*args, &proc)
      args.each do |arg|
        case arg
        when Numeric then @value = arg
        when String, Symbol then @name = arg.to_s
        else raise ArgumentError, "Bad argument(String|Symbol name, Numeric value, Proc proc) : #{arg}(#{arg.class})"
        end
      end
      @proc = proc
    end

    alias :get_value :value
    def value
      get_value or @proc && @proc.call.value
    end

    def to_s
      name || 'unnamed_variable'
    end

    def variables
      [self]
    end
  end
end