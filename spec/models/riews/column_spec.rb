require 'spec_helper'

describe Riews::View, type: :model do
  describe 'validates' do
    subject { build :column }
    describe 'view' do
      it { should belong_to(:riews_view) }
    end

    describe 'method' do
      let(:view) do
        new_view = build :view
        allow(new_view).to receive(:available_columns){ %w(one two three) }
        new_view
      end
      it 'is valid if it is contained in the available columns' do
        expect(build :column, view: view, method: 'one').to be_valid
      end
      it 'is invalid if it is not contained in the available columns' do
        expect(build :column, view: view, method: 'four').not_to be_valid
      end
    end
  end
end
