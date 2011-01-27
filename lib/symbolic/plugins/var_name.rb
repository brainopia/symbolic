# This is a simple module to give the name of the Ruby variable to the Symbolic::Variable
#   x = var #=> x = var :name => 'x')
# It can also name multiple variables (but with no options then):
#   x, y = vars
# This works with caller, and then need to be called directly

module Kernel
  alias :_var :var
  def var(options={}, &proc)
    unless options.has_key? :name
      file, ln = caller[0].split(':')

      options.merge!(
      :name => File.open(file) { |f|
        f.each_line.take(ln.to_i)[-1]
      }.match(/
        \s*([[:word:]]+)
        \s*=
        \s*var/x
      ) {
        $1
      })
    end
    _var(options, &proc)
  end

  def vars
    file, ln = caller[0].split(':')

    File.open(file) { |f|
      f.each_line.take(ln.to_i)[-1]
    }.match(/
      ((?:\s*[[:word:]]+?,?)+)
      \s*=
      \s*vars/x
    ) {
      $1
    }.scan(/([[:word:]]+)/).map { |capture|
      _var(:name => capture[0])
    }
  end
end
