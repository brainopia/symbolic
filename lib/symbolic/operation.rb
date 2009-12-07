class Symbolic::Operation
  include Symbolic

  def self.for(*args)
    simplify(*args) || new(*args)
  end
end