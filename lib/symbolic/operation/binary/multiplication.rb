class Symbolic::Operation::Binary::Multiplication < Symbolic::Operation::Binary
  symmetric

  def self.simplify_first_arg(var1, var2)
    if var1 == 0
      0
    elsif var1 == 1
      var2
    elsif negative?(var1)
      -(var1.abs * var2)
    end
  end

  def sign
    '*'
  end

  def brackets_for
    [:unary_minus, :addition, :subtraction]
  end
  # def initialize(var1, var2)
  #   super
  #   coef, numerators, denominators = unite_factors factors_of(var1), factors_of(var2)
  # end

  def unite_factors(factors1, factors2)
    c1, n1, d1 = factors1
    c2, n2, d2 = factors2
    return c1*c2, n1+n2, d1+d2
  end

  def factors_of(var)
    case var
    when Numeric
      [var, [], []]
    when Unary::Minus
      unite_factors [-1, [], []], factors_of(var.abs)
    when Binary::Multiplication
      [var.coef, var.nominators, var.denominators]
    else
      [[], [var], []]
    end
  end
end