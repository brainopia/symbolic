module Symbolic
=begin
blah
=end
  class Sum
    attr_reader :term, :index, :lb, :ub
    include Symbolic
    def initialize(term,index,lb,ub)
      @term, @index, @lb, @ub = term, index, lb, ub
    end
    def expand
      (lb..ub).collect{|i| @term.substitute(@index,i)}.inject{|m,t| m +t}
    end
    def variables
      @term.variables.reject{|var| var == @index}
    end
  end
end