module Symbolic
  class Expression
    include Symbolic

    attr_reader :var1, :var2, :operation

    def initialize(var1, var2, operation)
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

    def divide?
      @operation == '/'
    end

    def value
      if undefined_variables.empty?
        @var1.value.send @operation, @var2.value
      end
    end

    def variables
      @var1.variables | @var2.variables
    end

    def undefined_variables
      variables.select &:undefined?
    end

    def ==(object)
      object.is_a?(Expression) && (object.operation == @operation) &&
      ((object.var1 == @var1 && object.var2 == @var2) || ((plus? || multiply?) && (object.var1 == @var2 && object.var2 == @var1)))
    end

    def detailed_operations
      operations_of(@var1).tap {|it| it.merge!(operations_of @var2)[@operation] += 1 }
    end

    private

    def brackets(var)
      brackets_conditional(var) ? "(#{var})" : var.to_s
    end

    def brackets_conditional(var)
      %w(* /).include?(@operation) && (var.is_a?(UnaryMinus) || var.is_a?(Expression) && (var.plus? || var.minus?))
    end

    def operations_of(var)
      var.is_a?(Symbolic) ? var.detailed_operations : Hash.new(0)
    end
  end
end