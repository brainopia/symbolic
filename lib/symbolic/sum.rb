module Symbolic::Misc
=begin
blah
=end
  class Sum
    attr_reader :term, :index, :lb, :ub
    include Symbolic
    def initialize(term,index,lb,ub)
      @term, @index, @lb, @ub = term, index, lb, ub
    end
    def Sum.[](term,index,lb,ub)
      Symbolic::Sum.new(term,index,lb,ub)
    end
    def expand
      (lb..ub).collect{|ind| @term.subs(@index,ind)}.inject{|m,t| m + t}
    end
    def variables
      @term.variables.reject{|var| var == @index}
    end
    def diff(wrt)
      #TODO: error if wrt is the index
      if @term.diff(wrt) != 0
        Sum.new(@term.diff(wrt),@index,@lb,@ub)
      else
        0
      end
    end
    def variables
      @term.variables.reject{|var| var == @index} #@index doesn't really count
    end
    def value
      self.expand.value
    end
    def subs(to_replace, replacement=nil)
      #TODO: error if to_replace is @index
      if replacement == nil and to_replace.is_a?(Hash)
	super(to_replace)
      else
	Sum.new(@term.subs(to_replace, replacement),@index,@lb,@ub)
      end
    end
  end
end