module Symbolic
  # Basically, we have two main operations: + and *
  # They are the two Abelian groups:
  #    Op | Identity | PowerOp | Inverse
  # a + b | 0        | *       | -a
  # a * b | 1        | **      | 1/a
  class Abelian
    attr_writer :group
    # 1:coef, 2:base, 3:exponent
    # For * : 1 * 2 ** 3
    # For + : 1 + 2 *  3
    def initialize(*args)
      @coef, @base, @exp = case args.length
      when 1 # (coef = identity), base, (exp = 1)
        [identity, args[0], 1]
      when 2 # (coef = identity), base, exp
        [identity, *args]
      when 3 # coef, base, exp
        args
      end
    end

    def operation
      self.class::OPERATION
    end
    def identity
      self.class::IDENTITY
    end
    
    # Return the group, or a new one
    def group
      @group ||= self.class::GROUP.new(self)
    end

    def coerce(numeric)
      [Coerced.new(self), numeric]
    end

    def show # TEMP
      # simplify
    end
    #def to_s
    #  show.to_s
    #end

    # def value # TEMP
    #   @numeric.value.send(operation, @symbolic.value ** @exponent.value)
    # end
  end
end
