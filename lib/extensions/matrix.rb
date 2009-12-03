class Matrix
  def value
    map {|it| it.value }
  end

  def variables
    map {|it| it.variables }.to_a.flatten.uniq
  end

  def symbolic?
    !variables.empty?
  end
end