module Symbolic
  module Optimizations
    def self.addition(var1, var2)
      Addition.optimize(var1, var2) || Expression.new(var1, var2, '+')
    end

    def self.subtraction(var1, var2)
      Subtraction.optimize(var1, var2) || Expression.new(var1, var2, '-')
    end

    def self.multiplication(var1, var2)
      Multiplication.optimize(var1, var2) || Expression.new(var1, var2, '*')
    end

    def self.division(var1, var2)
      Division.optimize(var1, var2) || Expression.new(var1, var2, '/')
    end
  end
end