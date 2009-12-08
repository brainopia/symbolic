require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "symbolic"
    gem.version = '0.2.1'
    gem.summary = 'Symbolic math for ruby'
    gem.description = %Q{Symbolic math can be really helpful if you want to simplify some giant equation or if you don't want to get a performance hit re-evaluating big math expressions every time when few variables change.}
    gem.email = "ravwar@gmail.com"
    gem.homepage = "http://github.com/brainopia/symbolic"
    gem.authors = ["brainopia"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec