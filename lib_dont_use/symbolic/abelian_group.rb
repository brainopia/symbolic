module Symbolic
  class AbelianGroup
    include Operators
    attr_reader :members
    
    def initialize(*members)
      @members = members.flatten
    end
    
    def << o
      self.class.new( @members, AbelianGroup.member_of(self).new(o) )
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
    
    # Create a new group, yielding every element(with |base, power|)
    def new(&block)
      self.class.new @members.map { |member| member.new(&block) }
    end
    
    class << self
      def group_of(member)
        case member
        when Summand
          Summands.new(member)
        when Factor
          Factors.new(member)
        when Summands, Factors
          member
        else
          raise "No valid group for #{member}"
        end
      end
      
      def member_of(group)
        case group
        when Summands
          Summand
        when Factors
          Factor
        else
          raise "No valid element for #{member}"
        end
      end
    end
  end
end