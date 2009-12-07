module Symbolic::Math
  def self.cos(argument)
    Symbolic::Function.new argument, :cos
  end

  def self.sin(argument)
    Symbolic::Function.new argument, :sin
  end
end