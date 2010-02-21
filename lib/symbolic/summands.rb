module Symbolic
  class Summands < AbelianGroup
    #include Symbolic
    OPERATION = :+
    IDENTITY = 0
    def element
      Summand
    end
    
    def +(o)
      self << o
    end
    
    # TODO: 2*symbolic is a 2 power of symbolic Summand
    
    
  end
end