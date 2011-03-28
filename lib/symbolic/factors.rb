module Symbolic
  class Factors < Expression
    OPERATION = :*
    IDENTITY = 1
    class << self
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
        factors[1].delete_if {|base, exp| (base == IDENTITY) || (exp == 0) }
        factors[0] = 0 if factors[1].any? {|base, _| base == 0 }
      end

      def simplify(numeric, symbolic)
        if numeric == 0 || symbolic.empty?
          (numeric.round == numeric) ? numeric.to_i : numeric.to_f
        elsif numeric == IDENTITY && symbolic.size == 1 && symbolic.first[1] == 1
          symbolic.first[0]
        end
      end

      def unite_exponents(base, exponent)
        if base.is_a? Factors
          [base.numeric**exponent, Hash[*base.symbolic.map {|b,e| [b, e*exponent] }.flatten]]
        else
          [IDENTITY, { base => exponent }]
        end
      end
    end

    def reverse
      self.class.new numeric**-1, Hash[*symbolic.map {|k,v| [k,-v]}.flatten]
    end

    def value
      if variables.all?(&:value)
        @symbolic.inject(numeric) {|value, (base, exp)| value * base.value ** exp.value }
      end
    end

    def subs(to_replace, replacement=nil)
      if replacement == nil and to_replace.is_a?(Hash)
	super(to_replace)
      else
	@symbolic.inject(@numeric){|m,(base,exponential)| m * base.subs(to_replace, replacement) ** exponential.subs(to_replace, replacement)}
      end
    end

    def value
      @symbolic.inject(@numeric){|m,(base,exponential)| m * base.value ** exponential.value}
    end

    def diff(wrt)
      return 0 unless self.variables.include?(wrt) #speed things up a bit
      first_base, first_exp = @symbolic.to_a[0]
      first = first_base ** first_exp #the first factor
      self_without_first = self / first #the expression with the first factor removed
      #product rule to find derivitive
      udv = self_without_first.is_a?(Symbolic) ? first * self_without_first.diff(wrt) : 0
      vdu = first_base.is_a?(Symbolic) ? first_exp * first_base ** (first_exp - 1 ) * first_base.diff(wrt) * self_without_first : 0
      udv + vdu
    end
  end
end