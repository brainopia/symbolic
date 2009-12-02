module Symbolic
  class UnaryMinus < Operatable
    attr_reader :variable

    def self.create(var)
      var.is_a?(UnaryMinus) ? var.variable : new(var)
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

    def abs
      @variable
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