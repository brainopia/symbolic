module Symbolic
  class Factors < AbelianGroup
    OPERATION = :*
    IDENTITY = 1
    def element
      Factor
    end
  end
end