class Symbolic::Operation::Binary::Division < Symbolic::Operation::Binary
  def self.simplify_first_arg(var1, var2)
    if var1 == 0
      0
    elsif negative?(var1)
      -(var1.abs / var2)
    end
  end

  def self.simplify_second_arg(var1, var2)
    if var2 == 1
      var1
    elsif negative?(var2)
      -(var1 / var2.abs)
    end
  end

  def sign
    '/'
  end

  private

  def brackets_conditional(var)
    [:unary_minus, :addition, :subtraction].include? operation(var)
  end
end