module Symbolic
  class AbelianGroup
    include Operators
    attr_reader :members

    MEMBERS = {Summands => Summand, Factors => Factor}

    def initialize(*members)
      # to_add, others = members.partition { |m| self.class === m }
      # unless to_add.empty?
      #   first = to_add.shift
      #   to_add.each { |ta| first << ta }
      #   members = [first, *others]
      # end
      if members.length == 1 and self.class === members[0]
        @members = members[0].members
      else
        @members = members.map { |member| MEMBERS[self.class].new(member) }#.select { |m| m.value != identity }
      end
      optimize!
    end

    def member_class
      MEMBERS[self.class]
    end

    def << o
      if self.class === o # Let's not create nested group, but merge the members
        self.class.new( *(@members+o.members) )
      else
        self.class.new( *@members, o )
      end
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
      
      if @members.length >= 2 and @members[0].numeric? and @members[0].value < 0
        @members = @members.rotate(1)
      end
    end

    def optimize!
      # Nested same groups can be 'flatten'
      # nested, others = @members.partition { |m| self.class === m }
      # unless nested.empty?
      #   @members = others
      #   nested.each { |n| n.members.each { |member| @members << member } }
      # end
      
      simplify!
      sort!
      self
    end

    # Create a new group, yielding every element(with |base, power|)
    def new(&block)
      self.class.new(*@members.map { |member| member.new(&block) })
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
      def operation
        self::OPERATION
      end
      def identity
        self::IDENTITY
      end
    end
  end
end