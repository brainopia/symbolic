class Symbolic::Operation
  class Binary::Multiplication < Binary

    class << self
      def for(var1, var2)
        # TODO: def -@(var); -1 * var; end
        sign1, var1 = sign_and_modulus var1
        sign2, var2 = sign_and_modulus var2
        sign = (sign1 == sign2) ? :+@ : :-@

        factors = unite factors(var1), factors(var2)
        (simplify(factors) || new(factors)).send sign
      end

      def simplify(factors)
        factors.first if factors.length == 1
      end

      def unite(factors1, factors2)
        numeric = extract_numeric!(factors1) * extract_numeric!(factors2)
        return [0] if numeric == 0
        factors = unite_by_exponent factors1, factors2
        factors.unshift(numeric) if numeric != 1 || factors.empty?
        factors
      end

      def unite_by_exponent(factors1, factors2)
        exponents(factors1).
          merge(exponents factors2) {|base,exponent1,exponent2| exponent1 + exponent2 }.
          delete_if {|base, exponent| exponent == 0 }.
          map {|base, exponent| base**exponent }
      end

      def exponents(factors)
        exponents = factors.map {|it| base_and_exponent it }
        Hash[exponents]
      end

      def base_and_exponent(var)
        var.is_a?(Binary::Exponentiation) ? [var.send(:base), var.send(:exponent)] : [var, 1]
      end

      def extract_numeric!(factors)
        factors.first.is_a?(Numeric) ? factors.shift : 1
      end

      def sign_and_modulus(var)
        negative?(var) ? [:-@, var.abs] : [:+@, var]
      end

      def factors(var)
        var.respond_to?(:factors) ? var.send(:factors).dup : [var]
      end
    end

    def sign
      '*'
    end

    def brackets_for
      [:addition, :subtraction]
    end

    def initialize(factors)
      @factors = factors
    end

    def variables
      @factors.map(&:variables).flatten.uniq
    end

    def value
      @factors.inject(1) {|product, it| product*it.value } if undefined_variables.empty?
    end

    def to_s
      @factors.map {|it| brackets it }.join '*'
    end

    protected

    attr_reader :factors
  end
end