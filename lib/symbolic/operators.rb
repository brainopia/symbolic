module Symbolic
  module Operators
    UNARY_OPERATORS = [ :+@, :-@ ]
    BINARY_OPERATORS = [ :+, :-, :*, :/, :**]

    OPERATORS_HASH = { :+ => :-, :* => :/ }

    OPERATORS_RISING = {
      :+ => :*, :* => :**,
      :- => :/ #, :/ => :~
    }

    OPERATORS_GROUPS = {} # Will be filled by registering classes

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

    BINARY_OPERATORS.each { |op|
      define_method(op) { |o|
        group_class = OPERATORS_GROUPS[op]
        group = (group_class === self) ? self : group_class.new(self)

        # Basic simplifications
        # if o == group.identity # + 0, - 0, * 1, / 1 is doing nothing
        #   return self
        # elsif Abelian === self and self.value == group.identity and ( !(Variable === self) )
        #   if op == group.operation
        #     # 0 +, 1 * is doing nothing
        #     return o
        #   elsif op == Operators.inverse(group.operation)
        #     # 0 -, 1 /
        #     return group.member_class.new(o, -1) # o.new { |b,p|  }
        #   end
        # end
        return 1 if op == :** and (o == 0 or self == 1)

        case op
        when group.operation
          group << o
        when Operators.inverse(group.operation)
          #raise
          if op == :-
            group << o * -1
          else
            group << Abelian.new(o, -1)
          end
        when :+, :* # Factors + o, Summands * o
          group_class.new(group, o)
        #when :-, :/ # Factors - o, Summands / o
        #  group << Abelian.new(o, -1)
        when :** # OPERATORS_RISING[group.operation]
          group.renew { |b,p| [b, p*o] }
        else
          raise "#{self}(#{group}) #{op} #{o}"# group_class.new(group, o)
        end.optimized
      }
    }

    class << self
      def inverse(op)
        OPERATORS_HASH[op] || OPERATORS_HASH.key(op)
      end
    end
  end
end