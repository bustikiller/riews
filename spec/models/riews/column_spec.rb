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

  describe '#format' do
    let(:column){ build :column }
    it 'displays the content if no prefix or postfix is provided' do
      expect(column.format 'a').to eq 'a'
    end

    it 'uses the prefix if provided' do
      column.prefix = '->'
      expect(column.format 'a').to eq '->a'
    end

    it 'uses the postfix if provided'do
      column.postfix = '<-'
      expect(column.format 'a').to eq 'a<-'
    end

    it 'uses both the prefix and the postfix if provided'do
      column.prefix = '->'
      column.postfix = '<-'
      expect(column.format 'a').to eq '->a<-'
    end
  end
end
