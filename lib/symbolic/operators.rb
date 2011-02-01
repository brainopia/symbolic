module Symbolic
  module Operators
    UNARY_OPERATORS = [ :+@, :-@ ]
    BINARY_OPERATORS = [ :+, :-, :*, :/, :**]

    OPERATORS_HASH = { :+ => :-, :* => :/ }

    OPERATORS_RISING = {
      :+ => :*, :* => :**,
      :- => :/ #, :/ => :~
    }

    def coerce(numeric)
      [Abelian.new(numeric), self]
    end

    def +@
      self
    end

    def -@
      case self
      when Factors
        self << -1
      else
        Factors.new(self, -1)
      end.optimized
    end

    class << self
      def inverse(op)
        OPERATORS_HASH[op] || OPERATORS_HASH.key(op)
      end
    end
  end
end