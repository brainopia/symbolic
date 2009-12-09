class Symbolic::Operation
  include Symbolic

  def self.for(*args)
    simplify(*args) || new(*args)
  end

  def self.negative?(var)
    var.is_a?(Unary::Minus) || (var.is_a?(Numeric) && var < 0)
  end

  private

  def self.operation(expression)
    case expression
    when Unary::Minus           then :unary_minus
    when Binary::Addition       then :addition
    when Binary::Subtraction    then :subtraction
    when Binary::Multiplication then :multiplication
    when Binary::Division       then :division
    when Symbolic::Variable     then :variable
    end
  end

  def operation(expression)
    self.class.operation expression
  end

  def unary_minus?(expression)
    operation(expression) == :unary_minus
  end

  def addition?(expression)
    operation(expression) == :addition
  end

  def subtraction?(expression)
    operation(expression) == :subtraction
  end

  def multiplication?(expression)
    operation(expression) == :multiplication
  end

  def division?(expression)
    operation(expression) == :division
  end

  def variable?(expression)
    operation(expession) == :variable
  end

  def brackets(var)
    brackets_for.include?(operation var) ? "(#{var})" : var.to_s
  end

  def brackets_for
    []
  end
end