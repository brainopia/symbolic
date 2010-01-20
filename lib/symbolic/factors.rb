module Symbolic
  class Factors < Expression
    class << self
      def operation
        '*'
      end

      def identity_element
        1
      end

      def summands(summands)
        one summands
      end

      def factors(factors)
        factors
      end

      def power(base, exponent)
        simplify_expression! factors = unite_exponents(base, exponent)
        simplify(*factors) || new(*factors)
      end

      def add(var1, var2)
        if distributable? var1, var2
          distribute(var1, var2)
        elsif distributable? var2, var1
          distribute(var2, var1)
        else
          super
        end
      end

      def subtract(var1, var2)
        simplify_expression! factors = unite(convert(var1), convert(var2).reverse)
        simplify(*factors) || new(*factors)
      end

      def distributable?(var1, var2)
        simple?(var1) && var2.is_a?(Summands)
      end

      def distribute(var1, var2)
        var2.symbolic.map {|k,v| k*v }.inject(var2.numeric*var1) do |sum, it|
          sum + it*var1
        end
      end

      def simplify_expression!(factors)
        factors[1].delete_if {|base, exp| (base == identity_element) || (exp == 0) }
        factors[0] = 0 if factors[1].any? {|base, exp| base == 0 }
      end

      def simplify(numeric, symbolic)
        if numeric == 0 || symbolic.empty?
          (numeric.round == numeric) ? numeric.to_i : numeric.to_f
        elsif numeric == identity_element && symbolic.size == 1 && symbolic.values.first == 1
          symbolic.keys.first
        end
      end

      def unite_exponents(base, exponent)
        if base.is_a? Factors
          return base.numeric**exponent, Hash[*base.symbolic.map {|base,exp| [base,exp*exponent] }.flatten]
        else
          [identity_element, { base => exponent }]
        end
      end
    end

    def reverse
      self.class.new numeric**-1, Hash[*symbolic.map {|k,v| [k,-v]}.flatten]
    end

    def value
      if variables.all? &:value
        @symbolic.inject(numeric) {|value, (base, exp)| value * base.value ** exp.value }
      end
    end

    def to_s
      simplify_output
    end

    def coefficient_to_string(numeric)
      "#{'-' if numeric < 0}#{"#{Printer.rational numeric.abs}*" if numeric.abs != 1}"
    end

    def exponent_to_string(base, exponent)
      "#{brackets base}#{"**#{brackets exponent}" if exponent != 1}"
    end

    def brackets(var)
      [Numeric, Variable, Function].any? {|klass| var.is_a? klass } ? var : "(#{var})"
    end

    def simplify_output
      groups = @symbolic.group_by {|b,e| e.is_a?(Numeric) && e < 0 }
      reversed_factors = groups[true] ? [1, Hash[*groups[true].flatten] ] : nil
      factors = groups[false] ? [@numeric, Hash[*groups[false].flatten] ] : nil
      output = '' << (factors ? output(factors) : Printer.rational(@numeric))
      output << "/#{reversed_output reversed_factors}" if reversed_factors
      output
    end

    def output(factors)
      coefficient_to_string(factors[0]) <<
      factors[1].map {|base,exp| exponent_to_string base,exp }.join('*')
    end

    def reversed_output(factors)
      result = output [factors[0], Hash[*factors[1].map {|b,e| [b,-e] }.flatten]]
      (factors[1].length > 1) ? "(#{result})" : result
    end
  end
end