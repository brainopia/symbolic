module Symbolic
  class Coerced
    def initialize(symbolic)
      @symbolic = symbolic
    end

    def +(numeric)
      Operation::Binary::Addition.for numeric, @symbolic
    end

    def -(numeric)
      Operation::Binary::Subtraction.for numeric, @symbolic
    end

    def *(numeric)
      Operation::Binary::Multiplication.for numeric, @symbolic
    end

    def /(numeric)
      Operation::Binary::Division.for numeric, @symbolic
    end
  end
end