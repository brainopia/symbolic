module Kernel
  def var(*args, &proc)
    Symbolic::Variable.new(*args, &proc)
  end
end