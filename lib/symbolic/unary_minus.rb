module Symbolic
  class UnaryMinus < Operatable
    attr_reader :variable

    def self.create(expression)
      if expression.is_a? UnaryMinus
        expression.variable
      else
        new expression
      end
    end

    def initialize(variable)
      @variable = variable
    end

    def to_s
      if @variable.is_a? Variable
        "-#{@variable}"
      else
        "(-#{@variable})"
      end
    end

    def value
      -@variable.value if undefined_variables.empty?
    end

    def undefined_variables
      @variable.undefined_variables
    end

    def ==(object)
      object.is_a?(UnaryMinus) && object.variable == @variable
    end
  end
end