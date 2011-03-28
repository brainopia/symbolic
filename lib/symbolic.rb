module Symbolic
  def +@
    self
  end

  def -@
    Factors.add self, -1
  end

  def +(var)
    Summands.add self, var
  end

  def -(var)
    Summands.subtract self, var
  end

  def *(var)
    Factors.add self, var
  end

  def /(var)
    Factors.subtract self, var
  end

  def **(var)
    Factors.power self, var
  end

  def coerce(numeric)
    [Coerced.new(self), numeric]
  end

  def to_s
    Printer.print(self)
  end

  def inspect
    "Symbolic(#{to_s})"
  end

  def taylor(var, about, numterms=5)
    term = self
    #inject needs initial value to prevent it from eating the first term
    (0..numterms-1).inject(0) do |sum,n|
      to_add = term.subs(var,about) * (var - about) ** n / factorial(n)
      term = term.diff(var) #save a little time by not having to do all the derivites every time
      sum + to_add
    end
  end
  
  #make multiple substitutions using a hash. Ex: (x+y+z).subs({x=>2*y,z=>y**2}) results in y**2+3*y
  def subs(hsh)
    temp = self
    hsh.each{|k,v| temp = temp.subs(k,v)}
    temp
  end
  
end

#in order they should be loaded
['symbolic/expression.rb','symbolic/coerced.rb','symbolic/constants.rb','symbolic/factors.rb',
'symbolic/printer.rb','symbolic/sum.rb','symbolic/variable.rb','symbolic/constant.rb',
'symbolic/function.rb','symbolic/misc.rb','symbolic/statistics.rb',
'symbolic/summands.rb','symbolic/extensions/kernel.rb','symbolic/extensions/matrix.rb','symbolic/extensions/module.rb',
'symbolic/extensions/numeric.rb','symbolic/extensions/rational.rb','symbolic/math.rb'].each do |file|
  require File.dirname(__FILE__) + '/' + file
end
