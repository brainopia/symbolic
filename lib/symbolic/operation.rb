class Symbolic::Operation
  include Symbolic

  def self.for(*args)
    simplify(*args) || new(*args)
  end

  def self.negative?(var)
    var.is_a?(Unary::Minus) || (var.is_a?(Numeric) && var < 0)
  end
end