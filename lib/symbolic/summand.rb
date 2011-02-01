module Symbolic
  class Summand < Abelian
    OPERATION = :+
    IDENTITY = 0

    def operation
      OPERATION
    end
  end
end