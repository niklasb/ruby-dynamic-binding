module DynamicBinding
  class LookupStack
    def initialize(bindings = [])
      @bindings = bindings
    end

    def method_missing(m, *args)
      @bindings.reverse_each do |bind|
        begin
          method = eval("method(%s)" % m.inspect, bind)
        rescue NameError
        else
          return method.call(*args)
        end
        begin
          value = eval(m.to_s, bind)
          return value
        rescue NameError
        end
      end
      raise NoMethodError, "No such variable or method: %s" % m
    end

    def pop_binding
      @bindings.pop
    end

    def push_binding(bind)
      @bindings.push bind
    end

    def push_instance(obj)
      @bindings.push obj.instance_eval { binding }
    end

    def push_hash(vars)
      push_instance Struct.new(*vars.keys).new(*vars.values)
    end

    def get_binding
      instance_eval { binding }
    end

    def run_proc(p, *args)
      instance_exec(*args, &p)
    end

    def push_method(name, p, obj=nil)
      x = Object.new
      singleton = class << x; self; end
      singleton.send(:define_method, name, lambda { |*args|
        obj.instance_exec(*args, &p)
      })
      push_instance x
    end
  end
end

class Proc
  def call_with_binding(bind, *args)
    LookupStack.new([bind]).run_proc(self, *args)
  end
end
