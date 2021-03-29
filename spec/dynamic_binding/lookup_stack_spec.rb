require 'spec_helper'
require 'lib/dynamic_binding/lookup_stack'

describe DynamicBinding::LookupStack do
  let(:base) { 4 }

  let(:stack) {
    number = base
    DynamicBinding::LookupStack.new([binding])
  }

  describe '#run_proc' do
    context 'without arguments' do
      let(:p) { proc { number} }
      subject { stack.run_proc(p) }

      it { expect(subject).to eql base }
    end

    context 'with arguments' do
      let(:multiplier) { 4 }
      let(:addition) { 2 }

      let(:p) {
        proc {|mult, add| number*mult+add }
      }

      subject { stack.run_proc(p, multiplier, addition) }

      it { expect(subject).to eql base*multiplier+addition }
    end
  end
end
