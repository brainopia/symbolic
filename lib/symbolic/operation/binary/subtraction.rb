class Symbolic::Operation::Binary::Subtraction < Symbolic::Operation::Binary
  def self.simplify_first_arg(var1, var2)
    -var2 if var1 == 0
  end

  def self.simplify_second_arg(var1, var2)
    if var2 == 0
      var1
    elsif negative?(var2)
      var1 + var2.abs
    elsif [Addition, Subtraction].include? var2.class
      var1 + (-var2)
    end
  end

  def sign
    '-'
  end
end