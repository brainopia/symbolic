class Symbolic::Operation::Binary < Symbolic::Operation
  def create(var1, var2)
    # Optimizations.send name, var1, var2
  end

  def initialize(var1, var2)
    @arg1, @arg2 = var1, var2
  end

  protected

  attr_reader :arg1, :arg2
end