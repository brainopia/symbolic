class Symbolic::Factor
  include Symbolic

  class << self
    def exponent(base, exponent)
      simplify_exponents! factors = unite_exponents(base, exponent)
      simplify(*factors) || new(factors)
    end

    def multiply(var1, var2)
      simplify_exponents! factors = unite(factors(var1), factors(var2))
      simplify(*factors) || new(factors)
    end

    def factors(var)
      var.is_a?(Symbolic) ? var.send(:factors) : [var, {}]
    end

    def unite(factors1, factors2)
      numeric1, symbolic1 = factors1
      numeric2, symbolic2 = factors2

      numeric = numeric1 * numeric2
      symbolic = symbolic1.merge(symbolic2) {|base, exp1, exp2| exp1 + exp2 }
      return numeric, symbolic
    end

    def unite_exponents(base, exponent)
      if base.is_a? Symbolic::Factor
        numeric, symbolic = factors(base)
        return numeric**exponent, Hash[*symbolic.map {|base,exp| [base,exp*exponent] }.flatten]
      else
        [1, { base => exponent }]
      end
    end

    def simplify_exponents!(factors)
      factors[1].delete_if {|base, exp| (base == 1) || (exp == 0) }
      factors[0] = 0 if factors[1].any? {|base, exp| base == 0 }
    end

    def simplify(numeric, symbolic)
      if numeric == 0 || symbolic.empty?
        numeric
      elsif numeric == 1 && symbolic.size == 1 && symbolic.values.first == 1
        symbolic.keys.first
      end
    end
  end

  def initialize(factors)
    @factors = factors
  end

  def value
    @factors[1].inject(factors[0]) {|value, (base, exp)| value * base.value ** exp.value }
  end

  def variables
    @factors[1].map {|k,v| [k.variables, v.variables] }.flatten.uniq
  end

  def to_s
    coefficient_to_string(@factors[0]) <<
    @factors[1].map {|base,exp| exponent_to_string base,exp }.join('*')
  end

  def ==(object)
    object.send(:factors) == @factors rescue false
  end

  private

  attr_reader :factors

  def coefficient_to_string(numeric)
    "#{'-' if numeric < 0}#{"#{numeric.abs}*" if numeric.abs != 1}"
  end

  def exponent_to_string(base, exponent)
    "#{brackets base}#{"**#{brackets exponent}" if exponent != 1}"
  end

  def brackets(var)
    [Numeric, Symbolic::Variable].include?(var.class) ? var : "(#{var})"
  end
end