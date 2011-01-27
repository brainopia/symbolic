$LOAD_PATH.unshift File.expand_path('../../new', __FILE__)

# Quick hacks for rspec in Ruby 1.9
if RUBY_VERSION > "1.9"
  class String
    def collect(&b)
      lines.collect(&b)
    end
  end
end

require 'symbolic'
require 'rspec'
