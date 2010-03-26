module Symbolic
  module Operators
    UNARY_OPERATORS = [ :+@, :-@ ]
    BINARY_OPERATORS = [ :+, :-, :*, :/, :**]

    OPERATORS_HASH = { :+ => :-, :* => :/ }

    OPERATORS_RISING = {
      :+ => :*, :* => :**,
      :- => :/ #, :/ => :~
    }

    OPERATORS_GROUPS = {
      :+ => Summands,
      :- => Summands,
      :* => Factors,
      :/ => Factors,
      :** => Factors
    }

    def coerce(numeric)
      [Abelian.new(numeric), self]
    end
    
    def unary_operation(op)
      if op == :+@
        self
      else
        case self
        when Factors
          self << -1
        else
          Summand.new(self, -1)
        end
      end
    end
    
    def binary_operation(op, o)
      # TODO: call #optimized on result
      group_class = OPERATORS_GROUPS[op]
      if self.is_a? AbelianGroup
        group = self
      else
        # Make me a group !
        group = group_class.new(self)
      end

      # Basic simplifications
      if op == :* and [self, o].include? 0 # * 0 #=> 0
        return 0
      elsif o == group.identity # + 0, - 0, * 1, / 1 is doing nothing
        return self
      elsif Abelian === self and self.value == group.identity and ( !(Variable === self) )
        if op == group.operation
          # 0 +, 1 * is doing nothing
          return o
        elsif op == Operators.inverse(group.operation)
          # 0 -, 1 /
          return group_class.member_class.new(o, -1) # o.new { |b,p|  }
        end
      end

      case op
      when group.operation
        group << o
      when Operators.inverse(group.operation)
        #raise
        #group << o.inverse # -@ for Sum, **-1 for Fact
        group << Abelian.new(o, -1)
      when :+, :* # Factors + o , Summands * o
        group_class.new(group, o)
      when :** # OPERATORS_RISING[group.operation]
        if o == 0
          1
        else
          group.renew { |b,p| [b, p*o] }
        end
      else
        raise "#{self}(#{group}) #{op} #{o}"# group_class.new(group, o)
      end
    end

    def method_missing(op, *args, &block)
      if UNARY_OPERATORS.include?(op) and args.length == 0
        unary_operation(op)
      elsif BINARY_OPERATORS.include?(op) and args.length == 1
        binary_operation(op, args[0])
      else
        super
      end
    end

    class << self
      def inverse(op)
        OPERATORS_HASH[op] || OPERATORS_HASH.key(op)
      end
    end
  end
end