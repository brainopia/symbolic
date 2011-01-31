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

    def method_missing(op, *args, &block)
      result = if UNARY_OPERATORS.include?(op) and args.length == 0
        unary_operation(op)
      elsif BINARY_OPERATORS.include?(op) and args.length == 1
        binary_operation(op, args[0])
      else
        super
      end
      puts "#{self} #{op} #{args} => #{result}" if $VERBOSE
      result
    end

    class << self
      def inverse(op)
        OPERATORS_HASH[op] || OPERATORS_HASH.key(op)
      end
    end
  end
end