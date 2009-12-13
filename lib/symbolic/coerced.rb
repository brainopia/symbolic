module Symbolic
  class Coerced
    def initialize(symbolic)
      @symbolic = symbolic
    end

    def +(numeric)
      Summand.add numeric, @symbolic
    end

    def -(numeric)
      Summand.subtract numeric, @symbolic
    end

    def *(numeric)
      Factor.multiply numeric, @symbolic
    end

    def /(numeric)
      Factor.divide numeric, @symbolic
    end

    def **(numeric)
      Factor.exponent numeric, @symbolic
    end
  end
end