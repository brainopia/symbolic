class Module
  def simple_name
    name.split('::').last
  end
end
