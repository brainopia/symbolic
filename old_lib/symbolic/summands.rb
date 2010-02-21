# TODO: 2*symbolic is a 2 power of symbolic Summand
module Symbolic
  class Summands < Expression
    OPERATION = :+
    IDENTITY = 0
    class << self
      def summands(summands)
        summands
      end

      def factors(factors)
        if factors.symbolic.length == 1 && factors.symbolic.first[1] == Factors::IDENTITY
          new IDENTITY, factors.symbolic.first[0] => factors.numeric
        else
          new IDENTITY, Factors.new(1, factors.symbolic) => factors.numeric
        end
      end

      def simplify_expression!(summands)
        summands[1].delete_if {|base, coef| coef == 0 }
      end

      def simplify(numeric, symbolic)
        if symbolic.empty?
          numeric
        elsif numeric == IDENTITY && symbolic.size == 1
          symbolic.first[1] * symbolic.first[0]
        end
      end
    end

    def value
      if variables.all?(&:value)
        symbolic.inject(numeric) {|value, (base, coef)| value + base.value * coef.value }
      end
    end

    def reverse
      self.class.new( -numeric, Hash[*symbolic.map {|k,v| [k,-v]}.flatten] )
    end
  end
end