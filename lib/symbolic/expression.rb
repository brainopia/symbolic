module Symbolic
  class Expression < Operatable
    def initialize(var1, var2, operation)
      var1, var2 = var2, var1 if operation == '*' && var2.is_a?(Numeric)
      @var1, @var2, @operation = var1, var2, operation
    end

    def to_s
      "#{brackets @var1}#{@operation}#{brackets @var2}"
    end

    def plus?
      @operation == '+'
    end

    def minus?
      @operation == '-'
    end

    def multiply?
      @operation == '*'
    end

    def value
      if undefined_variables.empty?
        value_of(@var1).send @operation, value_of(@var2)
      end
    end

    def undefined_variables
      (undefined_variables_of(@var1) + undefined_variables_of(@var2)).uniq
    end

    private

    def brackets(var)
      brackets_conditional(var) ? "(#{var})" : var.to_s
    end

    def brackets_conditional(var)
      %w(* /).include?(@operation) && (var.is_a?(UnaryMinus) || var.is_a?(Expression) && (var.plus? || var.minus?))
    end

    def undefined_variables_of(variable)
      variable.is_a?(Operatable) ? variable.undefined_variables : []
    end

    def value_of(variable)
      variable.is_a?(Operatable) ? variable.value : variable
    end
  end
end