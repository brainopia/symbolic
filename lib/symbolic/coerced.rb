module Symbolic
  class Coerced
    def initialize(symbolic)
      @symbolic = symbolic
    end

    def +(numeric)
      Optimization.addition numeric, @symbolic
    end

    def -(numeric)
      Optimization.subtraction numeric, @symbolic
    end

    def *(numeric)
      Optimization.multiplication numeric, @symbolic
    end

    def /(numeric)
      Optimization.division numeric, @symbolic
    end
  end
end