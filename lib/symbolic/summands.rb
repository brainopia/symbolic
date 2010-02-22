module Symbolic
  class Summands < AbelianGroup
    OPERATION = :+
    IDENTITY = 0
    def element
      Summand
    end
    # TODO: 2*symbolic is a 2 power of symbolic Summand
  end
end