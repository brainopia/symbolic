module Symbolic  
  class Constant
    include Symbolic
    attr_reader :name, :value

    # Create a new Symbolic::Variable, with optional name, value and proc
    def initialize(value , name = nil)
      @name, @value = name, value
      @name = @name.to_s if @name
    end
    def subs(to_replace, replacement, expect_numeric = false)
      return replacement if self == to_replace
      #Consider the possibility that @value is not numeric?
      return @value if expect_numeric
      self
    end
    def diff(wrt)
      0
    end
    #yeah, it's not a variable, but it acts like one as far as value is concerned
    def variables
      [self]
    end
  end
end