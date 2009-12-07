class Symbolic::Operation::Binary < Symbolic::Operation
  def self.simplify(var1, var2)
    simplify_first_arg(var1, var2) || simplify_second_arg(var1, var2)
  end

  def initialize(var1, var2)
    @var1, @var2 = var1, var2
  end

  def variables
    @var1.variables | @var2.variables
  end

  def undefined_variables
    variables.select {|it| it.value.nil? }
  end

  def detailed_operations
    operations_of(@var1).tap {|it| it.merge!(operations_of @var2)[@operation] += 1 }
  end

  def to_s
    "#{brackets @var1}#{@operation}#{brackets @var2}"
  end

  def ==(object)
    (object.class == self.class) && (object.var1 == @var1 && object.var2 == @var2)
  end

  protected

  attr_reader :var1, :var2

  private

  def operations_of(var)
    var.is_a?(Symbolic) ? var.detailed_operations : Hash.new(0)
  end

  def brackets(var)
    brackets_conditional(var) ? "(#{var})" : var.to_s
  end
end