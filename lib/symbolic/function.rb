class Symbolic::Function
=begin
  This class is proxy for methods from Math module.
=end 
  include Symbolic
  attr_reader :argument, :operation
  def initialize(argument, operation)
    @argument, @operation = argument, operation
  end

  def value
    ::Math.send @operation, @argument.value if variables.all?(&:value)
  end

  def variables
    @argument.variables
  end

  def detailed_operations
    @argument.detailed_operations.tap {|it| it[@operation] += 1}
  end

  def subs(to_replace, replacement, expect_numeric = false)
    new_arg = @argument.subs(to_replace, replacement, expect_numeric)
    if new_arg.is_a?(::Numeric)
      ::Math.send @operation, new_arg
    else
      Function.new(new_arg, @operation)
    end  
  end
  
  def diff(wrt)
    return 0 unless self.variables.member?(wrt)
    #chain rule
    Function.operator_derivative(@operation, @argument) * @argument.diff(wrt)
  end
  
  def Function.operator_derivative(op,arg)
    case op
    when :sqrt then Rational(1,2) / arg ** Rational(1,2) #could keep it in terms of sqrt
    when :exp then Symbolic::Math.exp(arg)
    when :log then 1 / arg
    when :log10 then 1 / arg / Symbolic::Math.log(10) #since log10(x) = log(x) / log(10)
    when :cos then - Symbolic::Math.sin(arg)
    when :sin then Symbolic::Math.cos(arg)
    when :tan then 1 / Symbolic::Math.cos(arg) ** 2
    when :cosh then Symbolic::Math.sinh(arg) #no negative sign
    when :sinh then Symbolic::Math.cosh(arg)
    when :tanh then 1 / Symbolic::Math.cosh(arg) ** 2
    when :acos then - 1 / (1 - arg) ** Rational(1,2)
    when :asin then 1 / (1 - arg) ** Rational(1,2)
    when :atan then 1/ (arg**2 + 1)
#     when :atan2 then
    when :acosh then 1 / (1 - arg) ** Rational(1,2)
    when :asinh then 1 / (1 + arg) ** Rational(1,2)
    when :atanh then 1/ (1 - arg**2)
    end
  end
end

