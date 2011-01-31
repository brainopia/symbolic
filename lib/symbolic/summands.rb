require_relative 'abelian_group'

module Symbolic
  class Summands < AbelianGroup
    OPERATION = :+
    IDENTITY = 0
    # TODO: 2*symbolic is a 2 power of symbolic Summand
  end
end