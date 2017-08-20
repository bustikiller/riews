require 'spec_helper'

describe Riews::View, type: :model do
  describe 'validates' do
    subject { build :view, code: 'helloworld' }
    describe 'code' do
      it { should validate_presence_of(:code) }
      it { should validate_uniqueness_of(:code) }
    end
    describe 'paginator_size' do
      it { should validate_numericality_of(:paginator_size).is_greater_than_or_equal_to(0) }
    end
    describe 'accepts nested attributes for'  do
      it { should accept_nested_attributes_for(:columns).allow_destroy(true) }
      it { should accept_nested_attributes_for(:filter_criterias).allow_destroy(true) }
      it { should accept_nested_attributes_for(:relationships).allow_destroy(true) }
    end
  end
end
