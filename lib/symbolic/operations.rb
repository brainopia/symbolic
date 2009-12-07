module Symbolic
  module Operations
    def -@
      Operation::Unary::Minus.for self
    end

    def +@
      self
    end

    def +(var)
      Optimization.addition self, var
    end

    def -(var)
      Optimization.subtraction self, var
    end

    def *(var)
      Optimization.multiplication self, var
    end

    def /(var)
      Optimization.division self, var
    end

    def coerce(numeric)
      return Coerced.new(self), numeric
    end

    def operations
      detailed_operations.values.inject(0) {|sum,it| sum + it }
    end
  end
end