class Symbolic::Function
=begin
  This class is proxy for methods from Math module.
=end 
  include Symbolic
  attr_reader :argument, :name, :derivative, :operation
  
  #deriv can be either a function or a proc that takes an argument
  #operation can be either passed as a block or proc
  def initialize(argument, name, deriv = nil, op = nil, &block)
    @argument, @name, @derivative = argument, name, deriv
    unless op == nil
      @operation = op
    else
      @operation = block
    end
  end
  
  #it may be easier to set the derivitve after the object is made
  def set_derivative(deriv)
    #only allow it to be set if @derivative is nil
    @derivative = deriv if @derivative == nil
  end

  def value
    @operation.call(@argument.value) if variables.all?(&:value)
  end

  def variables
    @argument.variables
  end

  def detailed_operations
    @argument.detailed_operations.tap {|it| it[@operation] += 1}
  end

  #returns a function of the same type, but with arg replaced by new_arg
  def [] (new_arg)
    if new_arg.is_a?(::Numeric)
      @operation.call(new_arg)
    else
      Function.new(new_arg, @name, @derivative, @operation)
    end
  end
  
  def subs(to_replace, replacement)
    self[@argument.subs(to_replace, replacement)]
  end
  
  def diff(wrt)
    return 0 unless self.variables.member?(wrt)
    #TODO: raise exception if derivative == nil
    if @derivative.is_a?(Proc)
      #chain rule
      @derivative.call(@argument) * @argument.diff(wrt)
    else #it's a function
      @derivative[@argument] * @argument.diff(wrt)
    end
  end
end

