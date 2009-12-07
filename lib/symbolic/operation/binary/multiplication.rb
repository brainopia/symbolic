class Symbolic::Operation::Binary::Multiplication < Symbolic::Operation::Binary
  symmetric
  brackets_for :unary_minus, :addition, :subtraction

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
end