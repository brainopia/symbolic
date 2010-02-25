module Symbolic
  class AbelianGroup
    include Operators
    attr_reader :members
    
    def initialize(*members)
      # to_add, others = members.partition { |m| self.class === m }
      # unless to_add.empty?
      #   first = to_add.shift
      #   to_add.each { |ta| first << ta }
      #   members = [first, *others]
      # end
      @members = members.map { |member| Abelian.new(member) }#.select { |m| m.value{self} != identity }
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
      @members.inject(identity) { |val, member| val.send(operation, member.value{self}) }
    end
    
    def to_s
      # simplify!
      "{#{self.class.simple_name} #{@members.map { |m| m.to_s{self} }.join(', ')}}"
    end
    
    def simplify!
      # multiple Numeric values
      simple, others = @members.partition { |m| m.simple? }
      unless simple.empty?
        @members = [Abelian.new(self.class.new(*simple).value)] + others
      end
    end
    
    def optimize
      o = self
      # Nested same groups can be 'flatten'
      # nested, others = o.members.partition { |m| o.class === m }
      # unless nested.empty?
      #   o = o.class.new(others)
      #   nested.each { |n| n.members.each { |member| o << member } }
      # end
      o
    end
    
    # Create a new group, yielding every element(with |base, power|)
    def new(&block)
      self.class.new(*@members.map { |member| member.new(&block) })
    end
    
    def simple?
      false
    end
    
    def single?
      @members.length == 1
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