class Symbolic::Operation::Binary < Symbolic::Operation
  def self.simplify(var1, var2)
    simplify_first_arg(var1, var2) || simplify_second_arg(var1, var2)
  end

  def initialize(var1, var2)
    @var1, @var2 = var1, var2
  end

  protected

  attr_reader :var1, :var2
end