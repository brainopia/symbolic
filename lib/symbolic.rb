Dir[File.dirname(__FILE__) + "/symbolic/{,extensions/}*.rb"].each {|it| require it }

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
end