require_relative '../dynamic_binding'

class Proc
  def call_with_binding(bind, *args)
    DynamicBinding::LookupStack.new([bind]).run_proc(self, *args)
  end
end
