class Symbolic::Operations
  def self.for(*args)
    simplify(*args) || new(*args)
  end

  def initialize(*args)
    raise 'Abstract class'
  end

  def -@
    Unary::Minus.for self
  end

  def +@
    self
  end

  def +(var)
    Symbolic::Optimization.addition self, var
  end

  def -(var)
    Symbolic::Optimization.subtraction self, var
  end

  def *(var)
    Symbolic::Optimization.multiplication self, var
  end

  def /(var)
    Symbolic::Optimization.division self, var
  end

  def coerce(numeric)
    return Symbolic::Coerced.new(self), numeric
  end

  def operations
    detailed_operations.values.inject(0) {|sum,it| sum + it }
  end
end