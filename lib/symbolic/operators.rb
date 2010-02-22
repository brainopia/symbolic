module Symbolic
  module Operators
    OPERATORS = [ :+, :-, :*, :/, :**]
    
    OPERATORS_HASH = { :+ => :-, :* => :/ }
    
    OPERATORS_RISING = {
      :+ => :*, :* => :**,
      #:- => :/#, :/ => :~
    }
    
    def method_missing(op, *args, &blk)
      if OPERATORS.include?(op) and args.length == 1
        group = AbelianGroup.group_of(self)
        o = args[0]
        
        if self.operation == op
          group << o
        else
          if Summands === group
            case op
            when :*
              if Numeric === o
                # group.class.new group.members.map { |m| m.class.new(m.base, m.power * o) }
                # That line was really too long, no? :)
                group.new { |b,p| [b, p * o] }
              else
                Factors.new(self) << o
              end
            end
          elsif Factors === group
            
          end
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