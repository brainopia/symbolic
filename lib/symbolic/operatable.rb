module Symbolic
  class Operatable
    def -@
      UnaryMinus.create self
    end

    def *(value)
      Optimizations.multiply self, value
    end

    def +(value)
      Optimizations.plus self, value
    end

    def -(value)
      Optimizations.minus self, value
    end
  end
end