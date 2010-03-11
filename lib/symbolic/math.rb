module Symbolic::Math
=begin
  This module is a reflection for Math module which allows to use symbolic expressions as parameters for its methods.
=end
  
  require '/home/leon/Development/symbolic/lib/symbolic/function.rb'
  
  #sqrt = Symbolic::Function.new(nil,'sqrt', proc{|arg| Rational(1,2) / arg ** Rational(1,2)}) {|arg| ::Math.sqrt(arg)}
  def sqrt(arg)
    #sqrt[arg]
    arg ** Rational(1,2)
  end
  exp = Symbolic::Function.new(nil,'exp',nil) {|arg| ::Math.exp(arg)}
  exp.set_derivative(exp)
  def exp(arg)
    exp[arg]
  end
  log = Symbolic::Function.new(nil,'log', proc{|arg| 1 / arg}) {|arg| ::Math.log(arg)}
  def log(arg)
    log[arg]
  end
  log10 = Symbolic::Function.new(nil,'log10', proc{|arg| 1 / arg / ::Math.log(10)}) {|arg| ::Math.log10(arg)} #since log10(x) = log(x) / log(10)
  def log10(arg)
    log10[arg]
  end
  cos = Symbolic::Function.new(nil,'cos',nil) {|arg| ::Math.cos(arg)}
  sin = Symbolic::Function.new(nil,'sin',cos) {|arg| ::Math.sin(arg)}
  cos.set_derivative(proc{|arg| - cos[arg]})
  def cos(arg)
    cos[arg]
  end
  def sin(arg)
    sin[arg]
  end
  tan = Symbolic::Function.new(nil,'tan', proc{|arg| 1 / cos[arg] ** 2}) {|arg| ::Math.tan(arg)}
#     when 'cosh' then Symbolic::Math.sinh(arg) #no negative sign
#     when 'sinh' then Symbolic::Math.cosh(arg)
#     when 'tanh' then 1 / Symbolic::Math.cosh(arg) ** 2
#     when 'acos' then - 1 / (1 - arg) ** Rational(1,2)
#     when 'asin' then 1 / (1 - arg) ** Rational(1,2)
#     when 'atan' then 1/ (arg**2 + 1)
#     when 'acosh' then 1 / (1 - arg) ** Rational(1,2)
#     when 'asinh' then 1 / (1 + arg) ** Rational(1,2)
#     when 'atanh' then 1/ (1 - arg**2)

  
  
#     def Function.operator_derivative(name,arg)
#     case name
#     when 'sqrt' then Rational(1,2) / arg ** Rational(1,2) #could keep it in terms of sqrt
#     when 'exp' then Symbolic::Math.exp(arg)
#     when 'log' then 1 / arg
#     when 'log10' then 1 / arg / Symbolic::Math.log(10) #since log10(x) = log(x) / log(10)
#     when 'cos' then - Symbolic::Math.sin(arg)
#     when 'sin' then Symbolic::Math.cos(arg)
#     when 'tan' then 1 / Symbolic::Math.cos(arg) ** 2
#     when 'cosh' then Symbolic::Math.sinh(arg) #no negative sign
#     when 'sinh' then Symbolic::Math.cosh(arg)
#     when 'tanh' then 1 / Symbolic::Math.cosh(arg) ** 2
#     when 'acos' then - 1 / (1 - arg) ** Rational(1,2)
#     when 'asin' then 1 / (1 - arg) ** Rational(1,2)
#     when 'atan' then 1/ (arg**2 + 1)
# #     when :atan2 then
#     when 'acosh' then 1 / (1 - arg) ** Rational(1,2)
#     when 'asinh' then 1 / (1 + arg) ** Rational(1,2)
#     when 'atanh' then 1/ (1 - arg**2)
#     end
#   end
end