module Symbolic
  module Operators
  end
  
  class Abelian
  end
  class Variable < Abelian
  end
  
  class AbelianGroup
  end
  class Summands < AbelianGroup
  end
  class Factors < AbelianGroup
  end
  # def to_s
  #   Printer.print(self)
  # end

  # def inspect
  #   "Symbolic(#{to_s})"
  # end
end

(
Dir[File.dirname(__FILE__) + "/symbolic/*.rb"] +
Dir[File.dirname(__FILE__) + "/symbolic/extensions/*.rb"]
).each {|it| require it }