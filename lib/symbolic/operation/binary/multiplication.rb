class Symbolic::Operation::Binary::Multiplication < Symbolic::Operation::Binary
  def self.simplify_first_arg(var1, var2)
    if var1 == 0
      0
    elsif var1 == 1
      var2
    elsif negative?(var1)
      -(var1.abs * var2)
    end
  end

  def self.simplify_second_arg(var1, var2)
    simplify_first_arg var2, var1
  end

  def ==(object)
    (object.class == self.class) && ((object.var1 == @var1 && object.var2 == @var2) ||
    (object.var1 == @var2 && object.var2 == @var1))
  end

  def sign
    '*'
  end

  private

  def brackets_conditional(var)
    [:unary_minus, :addition, :subtraction].include? operation(var)
  end
end