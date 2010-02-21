class Symbolic::Function
=begin
  This class is proxy for methods from Math module.
=end
  include Symbolic
  attr_reader :argument, :operation
  def initialize(argument, operation)
    @argument, @operation = argument, operation
  end

  def value
    ::Math.send @operation, @argument.value if variables.all?(&:value)
  end

  def variables
    @argument.variables
  end

  def detailed_operations
    @argument.detailed_operations.tap {|it| it[@operation] += 1}
  end
end