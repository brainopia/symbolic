module Symbolic::Math
=begin
  This module is a reflection for Math module which allows to use symbolic expressions as parameters for its methods.
=end
  require "#{File.dirname(__FILE__)}/function.rb"
  require 'rational'  
  
  #for use in defining derivatives
  Arg = Symbolic::Variable.new(:name=>'arg')
  
  #first, make the functions with derivatives
  Sqrt  = Symbolic::Function.new('sqrt', proc{|arg| Rational(1,2) / arg ** Rational(1,2)})
#   Sqrt  = Symbolic::Function.new('sqrt', Rational(1,2) / Arg ** Rational(1,2))
  Exp   = Symbolic::Function.new('exp',proc{|arg| Exp[arg]})
  Log   = Symbolic::Function.new('log', proc{|arg| 1 / arg})
  Log10 = Symbolic::Function.new('log10',proc{|arg| 1 / arg / ::Math.log(10)}) #since log10(x) = log(x) / log(10)
  Cos   = Symbolic::Function.new('cos',proc{|arg| - Sin[arg]})
  Sin   = Symbolic::Function.new('sin',Cos)
  Tan   = Symbolic::Function.new('tan', proc{|arg| 1 / Cos[arg] ** 2})
  Cosh  = Symbolic::Function.new('cosh',proc{|arg| Sinh[arg]})
  Sinh  = Symbolic::Function.new('sinh',Cosh)
  Tanh  = Symbolic::Function.new('tanh',proc{|arg| 1 / Cosh(arg) ** 2})
  Acos  = Symbolic::Function.new('acos',proc{|arg| - 1 / (1 - arg) ** Rational(1,2)})
  Asin  = Symbolic::Function.new('asin',proc{|arg| 1 / (1 - arg) ** Rational(1,2)})
  Atan  = Symbolic::Function.new('atan',proc{|arg| 1/ (arg**2 + 1)})
  Acosh = Symbolic::Function.new('acosh',proc{|arg| 1 / (1 - arg) ** Rational(1,2)})
  Asinh = Symbolic::Function.new('asinh',proc{|arg| 1 / (1 + arg) ** Rational(1,2)})
  Atanh = Symbolic::Function.new('atanh',proc{|arg| 1/ (1 - arg**2)})

  #make functions of the form fctn(arg) and add operation to each function
  Symbolic::Math.constants.reject{|c| c == 'Arg'}.each do |fctn|
    instance_eval <<-CODE, __FILE__, __LINE__ + 1
      #{fctn}.set_operation(proc{|arg| ::Math.#{fctn.downcase}(arg)})
      def #{fctn.downcase}(argument)
        #{fctn}[argument]
      end
    CODE
  end
end