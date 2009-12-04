module Symbolic::Optimization::Division
  extend Symbolic::Optimization::Base

  def self.optimize_first_arg(var1, var2)
    if var1 == 0
      0
    elsif negative?(var1)
      -(var1.abs / var2)
    end
  end

  def self.optimize_second_arg(var1, var2)
    if var2 == 1
      var1
    elsif negative?(var2)
      -(var1 / var2.abs)
    end
  end
end