module Symbolic
  class Method
    include Symbolic

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

    def detailed_operations
      stats = @variable.detailed_operations.dup
      stats[@operation] += 1
      stats
    end
  end
end