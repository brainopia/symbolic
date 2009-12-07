class Symbolic::Operation::Unary < Symbolic::Operation
  def initialize(expression)
    @expression = expression
  end

  def variables
    @expression.variables
  end

  def undefined_variables
    @expression.undefined_variables
  end
end