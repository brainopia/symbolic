class Symbolic::Operation::Binary::Exponentiation < Symbolic::Operation::Binary
  def self.simplify_first_arg(var1, var2)
    # add conditional for negative?(var1) and even or odd values of var2
    if var1 == 0
      0
    elsif var1 == 1
      1
    elsif negative?(var1) && var2.respond_to?(:even?)
      without_sign = var1.abs ** var2
      var2.even? ? without_sign : -without_sign
    end
  end

  def self.simplify_second_arg(var1, var2)
    if var2 == 0
      1
    elsif var2 == 1
      var1
    end
  end

  def brackets_for
    [:unary_minus, :addition, :subtraction, :multiplication, :division]
  end

  def sign
    '**'
  end

  protected

  alias base var1
  alias exponent var2
end