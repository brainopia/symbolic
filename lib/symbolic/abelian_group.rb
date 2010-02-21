module Symbolic
  class AbelianGroup
    def initialize(*members)
      @members = members
    end
    
    def << o
      m = element.new(o)
      m.group = self
      @members << m
      self
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
  end
end