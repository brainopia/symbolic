module Symbolic
  class Factors < AbelianGroup
    #include Symbolic
    OPERATION = :*
    IDENTITY = 1
    def element
      Factor
    end
  end
end