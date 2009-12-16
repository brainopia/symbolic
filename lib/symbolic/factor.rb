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

    def divide(var1, var2)
      simplify_exponents! factors = unite(factors(var1), reverse(var2))
      simplify(*factors) || new(factors)
    end

    def simplify_exponents!(factors)
      factors[1].delete_if {|base, exp| (base == 1) || (exp == 0) }
      factors[0] = 0 if factors[1].any? {|base, exp| base == 0 }
    end

    def simplify(numeric, symbolic)
      if numeric == 0 || symbolic.empty?
        (numeric.round == numeric) ? numeric.to_i : numeric.to_f
      elsif numeric == 1 && symbolic.size == 1 && symbolic.values.first == 1
        symbolic.keys.first
      end
    end

    def reverse(var)
      factors(var).dup.tap do |it|
        it[0] = it[0]**-1
        it[1] = Hash[*it[1].map {|b,e| [b,-e] }.flatten]
      end
    end

    def factors(var)
      var.is_a?(Symbolic) ? var.send(:factors) : [var, {}]
    end

    def unite(factors1, factors2)
      numeric1, symbolic1 = factors1
      numeric2, symbolic2 = factors2

      numeric = numeric1 * numeric2
      symbolic = symbolic1.merge(symbolic2) {|base, exp1, exp2| exp1 + exp2 }
      [numeric, symbolic]
    end

    def unite_exponents(base, exponent)
      if base.is_a? Symbolic::Factor
        numeric, symbolic = factors(base)
        return numeric**exponent, Hash[*symbolic.map {|base,exp| [base,exp*exponent] }.flatten]
      else
        [1, { base => exponent }]
      end
    end
  end

  def initialize(factors)
    @factors = factors
  end

  def value
    @factors[1].inject(@factors[0]) {|value, (base, exp)| value * base.value ** exp.value }
  end

  def variables
    @factors[1].map {|k,v| [variables_of(k), variables_of(v)] }.flatten.uniq
  end

  def to_s
    simplify_output
  end

  def ==(object)
    object.send(:factors) == @factors rescue false
  end

  private

  attr_reader :factors

  def summands
    if @factors[0] == 1
      super
    else
      [0, {(self/@factors[0]) => @factors[0]}]
    end
  end

  def coefficient_to_string(numeric)
    "#{'-' if numeric < 0}#{"#{rational_to_string numeric.abs}*" if numeric.abs != 1}"
  end

  def exponent_to_string(base, exponent)
    "#{brackets base}#{"**#{brackets exponent}" if exponent != 1}"
  end

  def brackets(var)
    [Numeric, Symbolic::Variable].any? {|klass| var.is_a? klass } ? var : "(#{var})"
  end

  def simplify_output
    groups = @factors[1].group_by {|b,e| e.is_a?(Numeric) && e < 0 }
    reversed_factors = groups[true] ? [1, Hash[*groups[true].flatten] ] : nil
    factors = groups[false] ? [@factors[0], Hash[*groups[false].flatten] ] : nil
    output = '' << (factors ? output(factors) : rational_to_string(@factors[0]))
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

  def rational_to_string(numeric)
    ((numeric.round == numeric) ? numeric.to_i : numeric.to_f).to_s
  end
end