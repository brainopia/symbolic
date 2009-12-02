module Symbolic
  class UnaryMinus < Operatable
    def self.create(var)
      var.is_a?(UnaryMinus) ? var.abs : new(var)
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
      # add a common method for Operatable which will point to an instance of Abs(magnitude) class
      @variable
    end

    def value
      -@variable.value if undefined_variables.empty?
    end

    def undefined_variables
      @variable.undefined_variables
    end

    def ==(object)
      object.is_a?(UnaryMinus) && object.abs == @variable
    end
  end
end