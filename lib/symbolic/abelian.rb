module Symbolic
  # Basically, we have two main operations: + and *
  # They are the two Abelian groups:
  #    Op | Identity | PowerOp | Inverse
  # a + b | 0        | *       | -a
  # a * b | 1        | **      | 1/a
  class Abelian
    include Operators
    attr_reader :base, :power
    # 1:base, 2:power
    # For * : ... * (1 ** 2) * ...
    # For + : ... + (1 *  2) + ...
    def initialize(base, power = 1)
      @base, @power = base, power
    end
    
    def value
      @base.send(OPERATORS_RISING[operation], @power)
    end

    def operation
      self.class::OPERATION
    end
    def identity
      self.class::IDENTITY
    end
    
    #TEMP
    def to_s
      "<#{self.class.simple_name} #{@base}#{
        " #{OPERATORS_RISING[operation]} #{@power}" if @power != 1
      }>"
    end

    def coerce(numeric)
      [Coerced.new(self), numeric]
    end
  end
end
