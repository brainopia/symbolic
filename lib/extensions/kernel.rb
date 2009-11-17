module Kernel
  def var(options={})
    Symbolic::Variable.new options
  end

  def symbolic
    Symbolic.enabled = true
    yield
    Symbolic.enabled = false
  end
end