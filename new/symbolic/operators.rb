module Symbolic
  module Operators
    OPERATORS = [ :+, :-, :*, :/, :**]
    UNARY_OPERATORS = [ :+@, :-@ ]
    
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
    
    def method_missing(op, *args, &blk)
      if UNARY_OPERATORS.include?(op) and args.length == 0
        case op
        when :+@
          self
        when :-@
          Summands.new(self).new { |b,p| [b, p*-1] }
        end
      elsif OPERATORS.include?(op) and args.length == 1
        o = args[0]
        group_class = OPERATORS_GROUPS[op]
        if self.is_a? AbelianGroup
          group = self
        else
          # Make me a group !
          group = group_class.new(self)
        end
        
        if o == group.identity
          return self
        elsif Abelian === self and self.simple? and self.value == group.identity
          return o
        end
        
        case op
        when group.operation
          group << o
        when Operators.inverse(group.operation)
          #raise
          #group << o.inverse # -@ for Sum, **-1 for Fact
          group << Abelian.new(o, -1)
        when :* # Summands * o
          group_class.new(group, o)
        when :** # OPERATORS_RISING[group.operation]
            group.new { |b,p| [b, o*p] }
        else
          raise # group_class.new(group, o)
        end
        
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