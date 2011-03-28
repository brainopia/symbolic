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
    attr_accessor :name, :proc
    attr_writer :value

    # Create a new Symbolic::Variable, with optional name, value and proc
    def initialize(options={}, &proc)
      (@name, @value), @proc = options.values_at(:name, :value), proc
      @name = @name.to_s if @name
    end

    def value
      @value || @proc && @proc.call.value
    end

    def variables
      [self]
    end

    def subs(to_replace, replacement=nil, expect_numeric = false)
      if replacement == nil and to_replace.is_a?(Hash)
	super(to_replace)
      else
	return replacement if self == to_replace
	#Consider the possibility that @value is not numeric?
	return self.value if expect_numeric
	self
      end
    end

    def diff(wrt)
      return 1 if self == wrt
      0
    end
  end
end