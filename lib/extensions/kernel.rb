module Kernel
  def var(options={})
    Symbolic::Variable.new options
  end

  def symbolic
    Symbolic::Core.enable
    yield
    Symbolic::Core.disable
  end
end