class Symbolic::Operation
  class Unary::Minus < Unary
    def self.simplify(expression)
      case operation(expression)
      when :unary_minus
        expression.abs
      when :addition
        -expression.send(:var1)-expression.send(:var2)
      when :subtraction
        expression.send(:var2) - expression.send(:var1)
      end
    end

    def abs
      # TODO: implement Symbolic#abs
      @expression
    end

    def brackets_for
      [:addition, :subtraction]
    end

    def value
      -@expression.value if undefined_variables.empty?
    end

    def ==(object)
      object.is_a?(Unary::Minus) && object.abs == @expression
    end

    def detailed_operations
      @expression.detailed_operations.tap {|it| it['-@'] += 1}
    end

    def to_s
      "-#{brackets @expression}"
    end
  end
end