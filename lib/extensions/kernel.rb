module Kernel
  def var(options={})
    Symbolic::Variable.new options
  end

  def symbolic
    Symbolic::Core.enable
    result = yield
    Symbolic::Core.disable
    return result
  end
end