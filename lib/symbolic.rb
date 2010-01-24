Dir["#{File.dirname(__FILE__)}/symbolic/**/*.rb"].each { |f|
  case File.basename(f)
  when 'matrix.rb' # Only if Matrix was required before
    require f if Object.const_defined? 'Matrix'
  when 'rational.rb' # Fix for rational on 1.8.7
    require f if RUBY_VERSION == '1.8.7'
  else
    require f
  end
}

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

  private

  def variables_of(var)
    var.variables rescue []
  end
end