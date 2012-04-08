### Overview

This is a small experiment triggered by a [Stackoverflow
question](http://stackoverflow.com/questions/10058996/about-changing-binding-of-a-proc-in-ruby)
which realizes a certain, flexible form of dynamic binding in Ruby.

In particular, using this we can run an existing `Proc` instance in a new
context:

    require 'dynamic_binding'

    l = lambda { |a| a + foo }
    foo = 2
    l.call_with_binding(binding, 1)  # => 3

In addition to `Proc#call_with_binding`, we can also build up much more complex
lookup scenarios:

    require 'dynamic_binding'

    l = lambda { |a| local + func(2) + some_method(1) + var + a }

    local = 1
    def func(x) x end

    class Foo < Struct.new(:add)
      def some_method(x) x + add end
    end

    stack = DynamicBinding::LookupStack.new
    stack.push_binding(binding)
    stack.push_instance(Foo.new(2))
    stack.push_hash(:var => 4)

    p stack.run_proc(l, 5)  # => 15

Note that the lambda is defined at the *beginning* of the code, so none of
the names it accesses are actually captured by its closure!
