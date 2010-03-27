module Symbolic
  class AbelianGroup
    include Operators
    attr_reader :members

    MEMBERS = {Summands => Summand, Factors => Factor}

    def initialize(*members)
      @members = members.map { |member| member_class.new(member) }
      simplify!
    end

    def << o
      self.class.new( @members + [o] )
    end

    def operation
      self.class::OPERATION
    end
    def identity
      self.class::IDENTITY
    end

    def value
      @members.inject(identity) { |val, member| val.send(operation, member.value) }
    end

    def to_s
      #simplify!
      "{#{self.class.simple_name} #{@members.map { |m| m.to_s }.join(', ')}}"
    end

    def simplify!
      # multiple Numeric values
      numeric, symbolic = @members.partition(&:numeric?)
      if numeric.length > 1
        numeric = [ member_class.new(numeric.inject(identity) { |val, n| val.send(operation, n.value) }) ]
      end
      
      # If it's identity, we can remove it
      numeric = [] if !numeric.empty? and numeric[0].value == identity
      
      # We can group members with same base
      if self.class == Factors
        vars, subgroups = symbolic.partition { |m| m.respond_to?(:base) and Variable === m.base }
        vars = vars.inject({}) { |h, var| h.merge!({var.base => var.power}) { |base, oldpow, newpow| oldpow + newpow } }.
          each_pair.map { |(base, pow)| member_class.new(base, pow) }.reject { |m| m.power == 0 }
        symbolic = vars + subgroups
      end
      
      @members = numeric + symbolic
      
      ## Sorting
      
      # Two or more elements and first with negative sign, then put it at the end
      # if @members.length >= 2 and (
      #     @members[0].numeric? and @members[0].value < 0 or
      #     Summand === @members[0] and @members[0].power < 0
      #   )
      #   @members = @members.rotate(1)
      # end
      
      if @members.length >= 2
        neg, pos = @members.partition { |m|
          if m.numeric?
            m.value < 0
          elsif AbelianGroup === m
            m.members.any? { |subm| subm.numeric? and subm.value < 0 }
          else # Variable
            false
          end
        }
        @members = pos + neg
      end
      
    end

    # Create a new group, yielding every element(with |base, power|)
    def renew(&block)
      self.class.new(@members.map { |member| member.renew(&block) })
    end

    def numeric?
      @members.all?(&:numeric?)
    end

    def == object
      self.class == object.class and self.members == object.members
    end
    
    def optimized
      if @members.length == 2 and @members[0].numeric? and @members[0] == identity
        @members[1]
      end
      return @members[0].optimized if @members.length == 1
      self
    end
    
    def member_class
      MEMBERS[self.class]
    end

    class << self
      alias :_new :new
      def new(*args)
        args.flatten!
        raise "can't instantiate an AbelianGroup" if self == AbelianGroup
#        if args.any? { |m| self === m } # We will not nest same groups
          return self._new(*args.inject([]) { |members, m| members + (self === m ? m.members : [m]) })
#        end
#        _new(*args)
      end
      
      def operation
        self::OPERATION
      end
      def identity
        self::IDENTITY
      end
      
      def member_class
        MEMBERS[self]
      end
    end
  end
end