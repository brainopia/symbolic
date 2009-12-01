module Kernel
  def var(options={}, &proc)
    Symbolic::Variable.new options, &proc
  end

  def symbolic
    Symbolic::Core.enable
    result = yield
    Symbolic::Core.disable
    return result
  end
end