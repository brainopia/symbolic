module Symbolic::Math
=begin
  This module is a reflection for Math module which allows to use symbolic expressions as parameters for its methods.
=end
  
  #first, make the functions and take care of most of the derivatives
  Sqrt  = Symbolic::Function.new('sqrt', proc{|arg| Rational(1,2) / arg ** Rational(1,2)})
  Exp   = Symbolic::Function.new('exp',nil)
  Log   = Symbolic::Function.new('log', proc{|arg| 1 / arg})
  Log10 = Symbolic::Function.new('log10', proc{|arg| 1 / arg / ::Math.log(10)}) #since log10(x) = log(x) / log(10)
  Cos   = Symbolic::Function.new('cos',nil)
  Sin   = Symbolic::Function.new('sin',Cos)
  Tan   = Symbolic::Function.new('tan', proc{|arg| 1 / Cos[arg] ** 2})
  Cosh  = Symbolic::Function.new('cosh',nil)
  Sinh  = Symbolic::Function.new('sinh',Cosh)
  Tanh  = Symbolic::Function.new('tanh',proc{|arg| 1 / Cosh(arg) ** 2})
  Acos  = Symbolic::Function.new('acos',proc{|arg| - 1 / (1 - arg) ** Rational(1,2)})
  Asin  = Symbolic::Function.new('asin',proc{|arg| 1 / (1 - arg) ** Rational(1,2)})
  Atan  = Symbolic::Function.new('atan',proc{|arg| 1/ (arg**2 + 1)})
  Acosh = Symbolic::Function.new('acosh',proc{|arg| 1 / (1 - arg) ** Rational(1,2)})
  Asinh = Symbolic::Function.new('asinh',proc{|arg| 1 / (1 + arg) ** Rational(1,2)})
  Atanh = Symbolic::Function.new('atanh',proc{|arg| 1/ (1 - arg**2)})

  #take care of the remaining derivitves
  Exp.set_derivative(Exp)
  Cos.set_derivative(proc{|arg| - Sin[arg]})
  Cosh.set_derivative(Sinh)
  
  #make functions of the form fctn(arg) and add operation to each function
  Symbolic::Math.constants.each do |fctn|
    instance_eval <<-CODE, __FILE__, __LINE__ + 1
      #{fctn}.set_operation(proc{|arg| ::Math.#{fctn.downcase}(arg)})
      def #{fctn.downcase}(argument)
        #{fctn}[argument]
      end
    CODE
  end
end