module Symbolic
  class Factor < Abelian
    OPERATION = :*
    IDENTITY = 1

    def operation
      OPERATION
    end
  end
end
