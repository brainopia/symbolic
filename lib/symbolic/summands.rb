# TODO: 2*symbolic is a 2 power of symbolic Summand
module Symbolic
  class Summands < Expression
    class << self
      def operation
        '+'
      end

      def identity_element
        0
      end

      def summands(summands)
        summands
      end

      def factors(factors)
        if factors.symbolic.length == 1 && factors.symbolic.values.first == 1
          new identity_element, factors.symbolic.keys.first => factors.numeric
        else
          new identity_element, Factors.new(1, factors.symbolic) => factors.numeric
        end
      end

      def simplify_expression!(summands)
        summands[1].delete_if {|base, coef| coef == 0 }
      end

      def simplify(numeric, symbolic)
        if symbolic.empty?
          numeric
        elsif numeric == identity_element && symbolic.size == 1
          symbolic.values.first * symbolic.keys.first
        end
      end
    end

    def value
      symbolic.inject(numeric) {|value, (base, coef)| value + base.value * coef.value }
    end

    def to_s
      output = symbolic.map {|base, coef| coef_to_string(coef) + base.to_s }
      output << remainder_to_string(numeric) if numeric != 0
      output[0].sub!(/^\+/, '')
      output.join
    end

    def reverse
      self.class.new -numeric, Hash[*symbolic.map {|k,v| [k,-v]}.flatten]
    end

    def coef_to_string(coef)
      "#{(coef > 0) ? '+' : '-' }#{ "#{rational_to_string(coef.abs)}*" if coef.abs != 1}"
    end

    def remainder_to_string(numeric)
      "#{'+' if numeric > 0}#{numeric}"
    end

    def rational_to_string(numeric)
      ((numeric.round == numeric) ? numeric.to_i : numeric.to_f).to_s
    end
  end
end