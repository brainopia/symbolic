module Symbolic
  # Basically, we have two main operations: + and *
  # They are the two Abelian groups:
  #    Op | Identity | PowerOp | Inverse
  # a + b | 0        | *       | -a
  # a * b | 1        | **      | 1/a
  class Abelian
    # def initialize(base, exponent = 1, coef = self::IDENTITY)
    #   @base, @exponent, @coef = base, exponent, coef
    # end
    
    # From what I understand, numeric is just the coef, or the first element,
    # then the rest is called symbolic
    # and can be or a number, or a variable, or another Abelian (so a Symbolic expression)
    def initialize(numeric, symbolic)
      @numeric, @symbolic = numeric, symbolic
    end
    
    def operation
      self.class::OPERATION
    end
    
    def to_s # TEMP
      [@numeric, operation, @symbolic]
    end
    
    def value # TEMP
      @numeric.value.send(operation, @symbolic.value)
    end
  end
end
