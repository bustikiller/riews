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
      it 'is required if the pattern is not present' do
        expect(build :column, view: view, method: nil).not_to be_valid
      end
      it 'is forbidden if the pattern is present' do
        expect(build :column, view: view, method: 'one', pattern: 'helloworld').not_to be_valid
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

  describe '#replacement_tokens'do
    let(:view){ build :view }
    it 'returns an empty hash if the view has no persisted columns' do
      column = build :column, view: view
      expect(column.replacement_tokens).to be_empty
    end
    it 'returns a hash with the column ids as key in the format [[column:45]]' do
      allow(view).to receive(:available_columns){ %w(one two three) }
      column = create :column, view: view, method: 'one'
      expect(column.replacement_tokens.keys).to contain_exactly "[[column:#{column.id}]]"
    end

    it 'returns a hash with the column ids as key in the format [[column:45]] with several columns' do
      allow(view).to receive(:available_columns){ %w(one two three) }
      column1 = create :column, view: view, method: 'one'
      column2 = create :column, view: view, method: 'two'
      expect(column2.replacement_tokens.keys)
          .to contain_exactly "[[column:#{column1.id}]]", "[[column:#{column2.id}]]"
    end

    it 'excludes the columns that have a pattern' do
      allow(view).to receive(:available_columns){ %w(one two three) }
      column1 = create :column, view: view, method: 'one'
      column2 = create :column, view: view, pattern: 'This is a sample pattern'
      expect(column2.replacement_tokens.keys).to contain_exactly "[[column:#{column1.id}]]"
    end

    it 'calls the method #replacement_info for the details of the replacement' do
      allow(view).to receive(:available_columns){ %w(one two three) }
      column = create :column, view: view, method: 'one'
      info = { lorem: 'Ipsum' }
      allow_any_instance_of(Riews::Column).to receive(:replacement_info){info}
      expect(column.replacement_tokens.values).to contain_exactly info
    end
  end

  describe '#replacement_info'do
    it 'contains a key :description with the description of the pattern' do
      column = build :column, method: 'one'
      allow(column).to receive(:displayed_name){ 'My custom name' }
      expect(column.replacement_info[:description]).to eq 'Value of the column "My custom name"'
    end
  end
end
