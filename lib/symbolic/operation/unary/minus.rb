class Symbolic::Operation
  class Unary::Minus < Unary
    def self.simplify(expression)
      expression.abs if expression.is_a? Unary::Minus
    end

    def abs
      # TODO: implement Symbolic#abs
      @expression
    end

    def to_s
      if @expression.is_a?(Variable)
        "-#{@expression}"
      else
        "(-#{@expression})"
      end
    end

    def value
      -@expression.value if undefined_variables.empty?
    end

    def variables
      @expression.variables
    end

    def undefined_variables
      @expression.undefined_variables
    end

    def ==(object)
      object.is_a?(Unary::Minus) && object.abs == @expression
    end

    def detailed_operations
      @expression.detailed_operations.tap {|it| it['-@'] += 1}
    end
  end
end