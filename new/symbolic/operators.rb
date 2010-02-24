module Symbolic
  module Operators
    OPERATORS = [ :+, :-, :*, :/, :**]
    
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
      if OPERATORS.include?(op) and args.length == 1
        o = args[0]
        group_class = OPERATORS_GROUPS[op]
        
        if self.is_a? AbelianGroup
          group = self
        else
          # Make me a group !
          group = group_class.new(self)
        end
        
        case op
        when group.operation
          group << o
        when Operators.inverse(group.operation)
          #raise
          #group << o.inverse # -@ for Sum, **-1 for Fact
          group << Abelian.new(o, -1)
        else
          group_class.new(group, o)
        end
        
      else
        super
      end
    end
    
    def Summands(group, op, o)
      case op
      when :*
        group.single? ? group.new { |b,p| [b, p * o] } : Factors.new(self) << o
      end
    end
    
    def Factors(op, o)
      
    end
    
    def AbelianGroup(op, o)
      case op
      when :+
        Summands.new(self, o)
      end
    end
    
    class << self
      def inverse(op)
        OPERATORS_HASH[op] || OPERATORS_HASH.key(op)
      end
    end
  end
end