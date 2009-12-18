module Symbolic
=begin
  This class is used to create symbolic variables.
  Symbolic variables presented by name and value.
  Name is neccessary for printing meaningful symbolic expressions.
  Value is neccesary for calculation of symbolic expressions.
  If value isn't set for variable, but there is an associated proc, then value taken from evaluating the proc.
=end
  class Variable
    include Symbolic
    attr_accessor :name, :proc
    attr_writer :value

    def initialize(options={}, &proc)
      @name, @value = options.values_at(:name, :value)
      @name = @name.to_s if @name
      @proc = proc
    end

    def value
      @value || @proc && @proc.call.value
    end

    def to_s
      @name || 'unnamed_variable'
    end

    def variables
      [self]
    end
  end
end