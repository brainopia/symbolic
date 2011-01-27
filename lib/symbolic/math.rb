module Symbolic::Math
=begin
  This module is a reflection for Math module which allows to use symbolic expressions as parameters for its methods.
=end
  require "#{File.dirname(__FILE__)}/function.rb"
  require 'rational'

  #for use in defining derivatives
  Arg = Symbolic::Variable.new(:name=>'Arg')

  #first, make the functions with derivatives
  Abs   = Symbolic::Function.new('abs', proc{|arg| arg/Abs[arg]}){|arg| arg.abs}
  Sqrt  = Symbolic::Function.new('sqrt', Rational(1,2) / Arg ** Rational(1,2))
  Exp   = Symbolic::Function.new('exp'); Exp.set_derivative(Exp)
  Log   = Symbolic::Function.new('log', 1 / Arg)
  Log10 = Symbolic::Function.new('log10', 1 / Arg / ::Math.log(10)) #since log10(x) = log(x) / log(10)
  Cos   = Symbolic::Function.new('cos')
  Sin   = Symbolic::Function.new('sin',Cos); Cos.set_derivative(-Sin[Arg])
  Tan   = Symbolic::Function.new('tan', 1 / Cos[Arg] ** 2)
  Cosh  = Symbolic::Function.new('cosh')
  Sinh  = Symbolic::Function.new('sinh',Cosh); Cosh.set_derivative(Sinh)
  Tanh  = Symbolic::Function.new('tanh',1 / Cosh[Arg] ** 2)
  Acos  = Symbolic::Function.new('acos',- 1 / (1 - Arg) ** Rational(1,2))
  Asin  = Symbolic::Function.new('asin',1 / (1 - Arg) ** Rational(1,2))
  Atan  = Symbolic::Function.new('atan',1 / (Arg**2 + 1))
  Acosh = Symbolic::Function.new('acosh',1 / (1 - Arg) ** Rational(1,2))
  Asinh = Symbolic::Function.new('asinh',1 / (1 + Arg) ** Rational(1,2))
  Atanh = Symbolic::Function.new('atanh',1/ (1 - Arg**2))

  #make functions of the form fctn(arg) and add operation to each function
  #for ruby 1.9, we have to convert them to strings (they were strings in 1.8)
  Symbolic::Math.constants.collect{|c| c.to_s}.reject{|c| ['Arg','Abs'].include?(c)}.each do |fctn|
    instance_eval <<-CODE, __FILE__, __LINE__ + 1
      #{fctn}.set_operation(proc{|arg| ::Math.#{fctn.downcase}(arg)})
      def #{fctn.downcase}(argument)
        #{fctn}[argument]
      end
    CODE
  end
end