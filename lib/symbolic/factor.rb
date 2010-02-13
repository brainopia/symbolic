module Symbolic
  class Factor < Abelian
    OPERATION = :*
    IDENTITY = 1
    
    def -@
      @numeric *= -1
      self
    end
    
    def +(o)
      Summand.new(self, o)
    end
    
    def *(o)
      @numeric *= o
      self
    end
    
    def **(o)
      @numeric **= o
      @exponent *= o
      self
    end
  end
end
