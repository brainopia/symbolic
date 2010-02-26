[Fixnum,Bignum].each { |klass|
  klass.class_eval {
    alias :old_equal :==
    def == o # Make == both sense the same with Abelian
      if Symbolic::Abelian === o
        o == self
      else
        old_equal(o)
      end
    end
  }
}