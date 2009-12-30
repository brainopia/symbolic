class Symbolic::Function
  include Symbolic

  def initialize(variable, operation)
    @variable, @operation = variable, operation
  end

  def to_s
    "#{@operation}(#{@variable})"
  end

  def value
    ::Math.send @operation, @variable.value if variables.any? {|it| it.value.nil? }
  end

  def variables
    @variable.variables
  end

  def detailed_operations
    @variable.detailed_operations.tap {|it| it[@operation] += 1}
  end
end