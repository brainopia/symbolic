module Symbolic
  class Expression < Operatable
    attr_reader :var1, :var2, :operation

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
        @var1.value.send @operation, @var2.value
      end
    end

    def variables
      variables_of(@var1) | variables_of(@var2)
    end

    def undefined_variables
      variables.select &:undefined?
    end

    def ==(object)
      object.is_a?(Expression) && (object.operation == @operation) &&
      ((object.var1 == @var1 && object.var2 == @var2) || ((%w(+ *).include? @operation) && (object.var1 == @var2 && object.var2 == @var1)))
    end

    private

    def brackets(var)
      brackets_conditional(var) ? "(#{var})" : var.to_s
    end

    def brackets_conditional(var)
      %w(* /).include?(@operation) && (var.is_a?(UnaryMinus) || var.is_a?(Expression) && (var.plus? || var.minus?))
    end

    def variables_of(object)
      object.symbolic? ? object.variables : []
    end
  end
end