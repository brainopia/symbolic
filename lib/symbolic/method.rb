module Symbolic
  class Method < Operatable
    def initialize(variable, operation)
      @variable, @operation = variable, operation
    end

    def to_s
      "#{@operation}(#{@variable})"
    end

    def value
      Math.send @operation, @variable.value if undefined_variables.empty?
    end

    def variables
      @variable.variables
    end

    def undefined_variables
      @variable.undefined_variables
    end
  end
end