module Symbolic
  class AbelianGroup
    include Operators
    attr_reader :members

    MEMBERS = {Summands => Summand, Factors => Factor}

    def initialize(*members)
      @members = members.map { |member| MEMBERS[self.class].new(member) }#.select { |m| m.value != identity }
      optimize!
    end

    def member_class
      MEMBERS[self.class]
    end

    def << o
      self.class.new( *@members, o )
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
      #sort!
      "{#{self.class.simple_name} #{@members.map { |m| m.to_s }.join(', ')}}"
    end

    def simplify!
      # multiple Numeric values
      numbers, others = @members.partition { |m| m.numeric? }
      if !numbers.empty? and numbers.length > 1
        @members = others.unshift member_class.new( numbers.inject(identity) { |val, member| val.send(operation, member.value) } )
      end
    end

    def sort!
      # First numbers
      numbers, others = @members.partition { |m| m.numeric? }
      @members = numbers + others
      
      # Two or more elements and first with negative sign, then put it at the end
      if @members.length >= 2 and (
          @members[0].numeric? and @members[0].value < 0 or
          Summand === @members[0] and @members[0].power < 0
        )
        @members = @members.rotate(1)
      end
    end

    def optimize!
      simplify!
      sort!
    end

    # Create a new group, yielding every element(with |base, power|)
    def renew(&block)
      self.class.new(*@members.map { |member| member.renew(&block) })
    end

    def numeric?
      @members.all? { |member| member.numeric? }
    end

    def single?
      @members.length == 1
    end

    def == object
      if self.class == object.class
        self.members == object.members
      else
        false
      end
    end

    class << self
      alias :_new :new
      def new(*args)
        raise "can't instantiate an AbelianGroup" if self == AbelianGroup
        if args.all? { |arg| self === arg } # We will not nest same groups
          # currently not used
          self._new args.inject(args.shift.members) { |global, nested| global + nested }
        end
        _new(*args)
      end
      
      def operation
        self::OPERATION
      end
      def identity
        self::IDENTITY
      end
    end
  end
end