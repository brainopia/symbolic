class Module
  def simple_name
    name[name.rindex('::')+2..-1]
  end
end