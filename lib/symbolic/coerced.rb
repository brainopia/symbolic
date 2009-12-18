module Symbolic
=begin
 This class restores a correct order of arguments after using a coerce method.
 For example, expression "1 - symbolic" calls to Symbolic#coerce
 which gives us a power to reverse a receiver and parameter of method
 so we set a receiver as Coerced.new(symbolic) to reverse arguments back after coercing.
=end
  class Coerced
    def initialize(symbolic)
      @symbolic = symbolic
    end

    def +(numeric)
      Summands.add numeric, @symbolic
    end

    def -(numeric)
      Summands.subtract numeric, @symbolic
    end

    def *(numeric)
      Factors.add numeric, @symbolic
    end

    def /(numeric)
      Factors.subtract numeric, @symbolic
    end

    def **(numeric)
      Factors.power numeric, @symbolic
    end
  end
end