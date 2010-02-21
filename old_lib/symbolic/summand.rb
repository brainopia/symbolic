module Symbolic
  class Summand < Abelian
    OPERATION = :+
    IDENTITY = 0
    
    def -@
      @numeric  *= -1
      @symbolic *= -1
      self
    end
    
    def +(o)
      @symbolic = Summand.new(@symbolic, o)
      self
    end
    
    def -(o)
      @symbolic = Summand.new(@symbolic, -o)
      self
    end
    
    def *(o)
      Factor.new(o, self)
    end
    
    def **(o)
      Factor.new(1, self) ** o
    end
  end
end