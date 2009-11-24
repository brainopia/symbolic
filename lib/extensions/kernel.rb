module Kernel
  def var(options={})
    Symbolic::Variable.new options
  end

  def symbolic
    Symbolic.enable
    yield
    Symbolic.disable
  end
end