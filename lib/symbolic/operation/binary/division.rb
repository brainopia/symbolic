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

  def value
    @var1.value.send '/', @var2.value if undefined_variables.empty?
  end

  private

  def brackets_conditional(var)
    var.is_a?(Operation::Unary::Minus) || var.is_a?(Operation::Binary::Addition) || var.is_a?(Operation::Binary::Subtraction)
  end
end