require_relative '../variable'

module Kernel
  def var(options={}, &proc)
    Symbolic::Variable.new(options, &proc)
  end
end