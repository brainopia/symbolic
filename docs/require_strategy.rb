require 'graphviz' # ruby-graphviz

class String
  def camelize
    split('_').map(&:capitalize).join
  end
end

files = Dir['../lib/symbolic/*.rb']
constants = files.map { |f| File.basename(f, '.rb').camelize }
dependencies, require_dependencies = {}, {}

files.each { |file|
  base = File.basename(file, '.rb').camelize
  content = File.read(file)
  header = content[0...(content.index(/^\s*def\s\w+/) || -1)]
  require_dependencies[base] = content.scan(/^require_relative '(.*)'$/).reduce([], :+).map(&:camelize)
  dependencies[base] = header.scan(/\b(#{constants.join '|'})\b/).reduce([], :|).tap { |c| c.delete base }
}

# clean non direct dependencies
dependencies.each_pair { |base, deps|
  deps.reject! { |dep| deps.find { |sub_dep| dependencies[sub_dep].include? dep } }
}

dependencies.each_pair { |base, deps|
  puts "#{base} => #{deps.join ' '}"
}

if dependencies == require_dependencies
  puts "All require are good !"
else
  puts "All require do not match real dependencies !"
  require_dependencies.each_pair { |base, deps|
    unless dependencies[base] == deps
      puts "Dependencies for #{base} should be:"
      puts dependencies[base].join(', ')
      puts "But are instead:"
      puts deps.join(', ')
    end
  }
end

g = GraphViz.digraph('"Symbolic require Strategy"', type: :digraph)

def g.node name
  get_node(name) or add_node(name)
end

dependencies.each_pair { |base, deps|
  base = g.node base
  deps = deps.map { |d| g.node d }
  deps.each { |dep|
    dep >> base
  }
}

symbolic = g.node('Symbolic')

(dependencies.keys - dependencies.values.reduce(:concat)).each { |top|
  g.node(top) >> symbolic
}

# can be seen at http://brainopia.github.com/symbolic/require_strategy.svg
g.output svg: 'require_strategy.svg'
