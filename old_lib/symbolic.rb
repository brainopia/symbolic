(
Dir[File.dirname(__FILE__) + "/symbolic/*.rb"] +
Dir[File.dirname(__FILE__) + "/symbolic/extensions/*.rb"]
).each {|it| require it }

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

  # def inspect
  #   "Symbolic(#{to_s})"
  # end

  private

  def variables_of(var)
    var.variables rescue []
  end
end