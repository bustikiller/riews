require 'spec_helper'

describe Riews::View, type: :model do
  describe 'validates' do
    subject { build :view, code: 'helloworld' }
    describe 'code' do
      it { should validate_presence_of(:code) }
      it { should validate_uniqueness_of(:code) }
    end
  end
end
