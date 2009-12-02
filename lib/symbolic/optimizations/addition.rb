module Symbolic::Optimization::Addition
  extend Symbolic::Optimization::Base

  def self.optimize_first_arg(var1, var2)
    if var1 == 0
      var2
    elsif negative?(var1)
      var2 - var1.abs
    end
  end

  def self.optimize_second_arg(var1, var2)
    optimize_first_arg var2, var1
  end
end