require 'spec_helper'
require 'lib/core_ext/proc'

describe Proc do
  let(:base) { 4 }

  describe '#call_with_binding' do
    context 'without arguments' do
      let(:p) { proc { number } }

      subject {
        number = base
        p.call_with_binding(binding)
      }

      it { expect(subject).to eql base }
    end

    context 'with arguments' do
      let(:multiplier) { 4 }
      let(:addition) { 2 }

      let(:p) {
        proc {|mult, add| number*mult+add }
      }

      subject {
        number = base
        p.call_with_binding(binding, multiplier, addition)
      }

      it { expect(subject).to eql base*multiplier+addition }
    end
  end
end
