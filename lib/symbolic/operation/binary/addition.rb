class Symbolic::Operation::Binary::Addition < Symbolic::Operation::Binary
  def self.simplify_first_arg(var1, var2)
    if var1 == 0
      var2
    elsif negative?(var1)
      var2 - var1.abs
    end
  end

  def self.simplify_second_arg(var1, var2)
    simplify_first_arg var2, var1
  end
end