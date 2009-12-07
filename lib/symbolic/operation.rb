class Symbolic::Operation
  include Symbolic::Operations

  def self.for(*args)
    simplify(*args) || new(*args)
  end
end