module Symbolic
  class Abelian
    attr_reader :base, :exponent

    def initialize(base, exponent=identity)
      @base, @exponent = base, exponent
    end
  end
end