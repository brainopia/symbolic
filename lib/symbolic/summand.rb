class Symbolic::Summand
  include Symbolic

  class << self
    def add(var1, var2)
      simplify_coefficients! summands = unite(summands(var1), summands(var2))
      simplify(*summands) || new(summands)
    end

    def subtract(var1, var2)
      simplify_coefficients! summands = unite(summands(var1), reverse(var2))
      simplify(*summands) || new(summands)
    end

    def reverse(var)
      summands(var).tap do |it|
        it[0] = -it[0]
        it[1] = Hash[*it[1].map {|b,e| [b,-e] }.flatten]
      end
    end

    def summands(var)
      var.is_a?(Symbolic) ? var.send(:summands) : [var, {}]
    end

    def unite(summands1, summands2)
      numeric1, symbolic1 = summands1
      numeric2, symbolic2 = summands2

      numeric = numeric1 + numeric2
      symbolic = symbolic1.merge(symbolic2) {|base, coef1, coef2| coef1 + coef2 }
      [numeric, symbolic]
    end

    def simplify_coefficients!(summands)
      summands[1].delete_if {|base, coef| coef == 0 }
    end

    def simplify(numeric, symbolic)
      if symbolic.empty?
        numeric
      elsif numeric == 0 && symbolic.size == 1
        symbolic.values.first * symbolic.keys.first
      end
    end
  end

  def initialize(summands)
    @summands = summands
  end

  def value
    @summands[1].inject(@summands[0]) {|value, (base, coef)| value + base.value * coef.value }
  end

  def variables
    @summands[1].map {|k,v| [variables_of(k), variables_of(v)] }.flatten.uniq
  end

  def ==(object)
    object.send(:summands) == @summands rescue false
  end

  def to_s
    output = @summands[1].map {|base, coef| coef_to_string(coef) + base.to_s }
    output << remainder_to_string(@summands[0]) if @summands[0] != 0
    output[0] = output.first[1..-1]
    output.join
  end

  private

  attr_reader :summands

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