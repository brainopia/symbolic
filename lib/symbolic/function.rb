class Symbolic::Function
=begin
  This class is wrapper around calls to Math module.
=end
  include Symbolic

  def initialize(argument, operation)
    @argument, @operation = argument, operation
  end

  def to_s
    "#{@operation}(#{@argument})"
  end

  def value
    ::Math.send @operation, @argument.value if variables.any? {|it| it.value.nil? }
  end

  def variables
    @argument.variables
  end

  def detailed_operations
    @argument.detailed_operations.tap {|it| it[@operation] += 1}
  end
end