class Symbolic::Operation::Binary::Addition < Symbolic::Operation::Binary
  symmetric

  def self.simplify_first_arg(var1, var2)
    if var1 == 0
      var2
    elsif negative?(var1)
      var2 - var1.abs
    end
  end

  def sign
    '+'
  end
end