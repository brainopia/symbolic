module Symbolic
  module Operators
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