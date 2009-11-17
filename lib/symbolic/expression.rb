module Symbolic
  class Expression < Operatable
    def initialize(var1, var2, operation)
      var1, var2 = var2, var1 if operation == '*' && var2.is_a?(Numeric)
      @var1, @var2, @operation = var1, var2, operation
    end

    def to_s
      var1 = "#{@var1}"
      var2 = "#{@var2}"
      if @operation == '*'
        var1 = "(#{@var1})" if @var1.is_a?(Expression) && (@var1.plus? || @var1.minus?)
        var2 = "(#{@var2})" if @var2.is_a?(Expression) && (@var2.plus? || @var1.minus?)
      end
      "#{var1}#{@operation}#{var2}"
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

    def undefined_variables_of(variable)
      variable.is_a?(Operatable) ? variable.undefined_variables : []
    end

    def value_of(variable)
      variable.is_a?(Operatable) ? variable.value : variable
    end
  end
end