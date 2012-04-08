require 'ostruct'

module DynamicBinding
  class LookupStack
    def initialize(bindings = [])
      @bindings = bindings
    end

    def method_missing(m, *args)
      @bindings.each do |bind|
        begin
          method = eval("method(%s)" % m.inspect, bind)
          return method.call(*args)
        rescue NameError
        end
        begin
          value = eval(m.to_s, bind)
          return value
        rescue NameError
        end
      end
      raise NoMethodError
    end

    def push_binding(bind)
      @bindings.push bind
    end

    def push_instance(obj)
      @bindings.push obj.instance_eval { binding }
    end

    def push_hash(vars)
      push_instance OpenStruct.new(vars)
    end

    def run_proc(p, *args)
      instance_exec(*args, &p)
    end
  end
end

class Proc
  def call_with_binding(bind, *args)
    LookupStack.new([bind]).run_proc(self, *args)
  end
end
