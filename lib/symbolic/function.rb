module Symbolic
  class Function
    attr_reader :name, :deriv, :operation
    
    #deriv can be either a function or a proc that takes an argument -- it can be set later
    #operation can be passed as a block, a proc, or set later
    def initialize(name, deriv = nil, op = nil, &block)
      @name, @deriv = name, deriv
      unless op == nil
	@operation = op
      else
	@operation = block
      end
    end
    
    #it may be easier to set the derivitve after the object is made
    def set_derivative(deriv)
      #only allow it to be set if @derivative is nil
      @deriv = deriv if @deriv == nil
    end
 
    def set_operation(op)
      #only allow it to be set if @derivative is nil
      @operation = op if @operation == nil
    end
    
    #returns a FunctionWrapper with the argument or a number
    def [] (arg)
      if arg.is_a?(::Numeric) #take care of the case where arg is a number
	self.call(arg)
      else
	FunctionWrapper.new(arg, self)
      end
    end
    
    #same but with different syntax
    def arg(arg)
      self[arg]
    end
    
    #returns the derivitve with arg plugged in -- for use with chainrule
    def derivative(arg)
      if @deriv.is_a?(Proc)
        @deriv.call(arg)
      elsif @deriv.is_a?(Function)
        @deriv[arg]
      else  #by process of elimination, it's a Symbolic
        @deriv.subs(Symbolic::Math::Arg,arg)
      end
    end
    
    def call(arg)
      @operation.call(arg)
    end
  end
  
  #class combines a function with an argument or arguments
  #this class is what allows functions to be used in symbolic expressions
  class FunctionWrapper
    include Symbolic  
    attr_reader :argument, :function
    
    def initialize(arg, fctn)
      @argument, @function = arg, fctn  
    end
    
    def name
      @function.name
    end
    
    def value
      @function.call(@argument.value) if variables.all?(&:value)
    end
 
    def variables
      @argument.variables
    end
 
    def detailed_operations
      @argument.detailed_operations.tap {|it| it[@operation] += 1}
    end    
    
    def subs(to_replace, replacement, expect_numeric = false)
      @function[@argument.subs(to_replace, replacement, expect_numeric)]
    end
    
    #simply dumps @argument in to the function -- no gaurentee that the function
    #will know how to handle it. Useful in some circumstances
    def eval
      @function.call(@argument)
    end
    
    def diff(wrt)
      return 0 unless self.variables.member?(wrt)
      #chain rule
      @function.derivative(@argument)  * @argument.diff(wrt)
    end
  end
end