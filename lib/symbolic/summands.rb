require_relative 'abelian_group'
require_relative 'summand'

module Symbolic
  class Summands < AbelianGroup
    OPERATION = :+
    IDENTITY = 0

    AbelianGroup::MEMBERS[self] = Summand
    # TODO: 2*symbolic is a 2 power of symbolic Summand
  end
end