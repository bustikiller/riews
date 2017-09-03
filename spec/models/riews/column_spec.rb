require 'spec_helper'

describe Riews::View, type: :model do
  describe 'validates' do
    subject { build :column }
    describe 'view' do
      it { should belong_to(:riews_view) }
    end

    let(:view) do
      new_view = build :view
      allow(new_view).to receive(:available_columns){ %w(one two three) }
      new_view
    end

    describe 'method' do
      it 'is valid if it is contained in the available columns' do
        expect(build :column, view: view, method: 'one').to be_valid
      end
      it 'is invalid if it is not contained in the available columns' do
        expect(build :column, view: view, method: 'four').not_to be_valid
      end
    end

    describe 'column role' do
      it 'cannot have both method and pattern' do
        expect(build :column, view: view, method: 'one', pattern: 'helloworld').not_to be_valid
      end
      it 'cannot have both pattern and links' do
        column = build :column, view: view, pattern: 'helloworld'
        column.action_links.build
        expect(column).not_to be_valid
      end
      it 'cannot have both method and links' do
        column = build :column, view: view, method: 'one'
        column.action_links.build
        expect(column).not_to be_valid
      end
      it 'cannot have method, pattern and links' do
        column = build :column, view: view, method: 'one', pattern: 'helloworld'
        column.action_links.build
        expect(column).not_to be_valid
      end
      it 'can have just method' do
        expect(build :column, view: view, method: 'one').to be_valid
      end

      it 'can have just pattern' do
        expect(build :column, view: view, pattern: 'helloworld').to be_valid
      end

      it 'can have just links' do
        column = build :column, view: view
        column.action_links.build base_path: 'path', display_pattern: 'pattern'
        expect(column).to be_valid
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
    it 'contains the calculations pattern' do
      column = build :column, view: view
      expect(column.replacement_tokens.keys).to include '[[calc:(<math expression>)]]'
    end
    it 'contains the icons pattern' do
      column = build :column, view: view
      expect(column.replacement_tokens.keys).to include '[[icon:<glyphicon>]]'
    end
    it 'returns a hash with the column ids as key in the format [[column:45]]' do
      allow(view).to receive(:available_columns){ %w(one two three) }
      column = create :column, view: view, method: 'one'
      expect(column.replacement_tokens.keys).to include "[[column:#{column.id}]]"
    end

    it 'returns a hash with the column ids as key in the format [[column:45]] with several columns' do
      allow(view).to receive(:available_columns){ %w(one two three) }
      column1 = create :column, view: view, method: 'one'
      column2 = create :column, view: view, method: 'two'
      expect(column2.replacement_tokens.keys)
          .to include "[[column:#{column1.id}]]", "[[column:#{column2.id}]]"
    end

    it 'excludes the columns that have a pattern' do
      allow(view).to receive(:available_columns){ %w(one two three) }
      column1 = create :column, view: view, method: 'one'
      column2 = create :column, view: view, pattern: 'This is a sample pattern'
      expect(column2.replacement_tokens.keys).not_to include "[[column:#{column2.id}]]"
    end

    it 'calls the method #replacement_info for the details of the replacement' do
      allow(view).to receive(:available_columns){ %w(one two three) }
      column = create :column, view: view, method: 'one'
      info = { lorem: 'Ipsum' }
      allow_any_instance_of(Riews::Column).to receive(:replacement_info){info}
      expect(column.replacement_tokens.values).to include info
    end
  end

  describe '#replacement_info'do
    it 'contains a key :description with the description of the pattern' do
      column = build :column, method: 'one'
      allow(column).to receive(:displayed_name){ 'My custom name' }
      expect(column.replacement_info[:description]).to eq 'Value of the column "My custom name"'
    end
  end

  describe '#db_column' do
    it 'returns a sum statement when the aggregation function is sum' do
      column = build :column, method: 'age', aggregate: Riews::Column.functions[:sum]
      expect(column.db_column).to eq 'SUM(age)'
    end
    it 'returns a max statement when the aggregation function is max' do
      column = build :column, method: 'age', aggregate: Riews::Column.functions[:max]
      expect(column.db_column).to eq 'MAX(age)'
    end
    it 'returns a min statement when the aggregation function is min' do
      column = build :column, method: 'age', aggregate: Riews::Column.functions[:min]
      expect(column.db_column).to eq 'MIN(age)'
    end
    it 'returns a avg statement when the aggregation function is avg' do
      column = build :column, method: 'age', aggregate: Riews::Column.functions[:avg]
      expect(column.db_column).to eq 'AVG(age)'
    end
    it 'returns a count statement when the aggregation function is count' do
      column = build :column, method: 'age', aggregate: Riews::Column.functions[:count]
      expect(column.db_column).to eq 'COUNT(*)'
    end
    it 'returns the method as string if the aggregation function is group' do
      column = build :column, method: 'age', aggregate: Riews::Column.functions[:group]
      expect(column.db_column).to eq 'age'
    end
    it 'returns the method as a symbol if the aggregation function is not valid' do
      column = build :column, method: 'age', aggregate: 45
      expect(column.db_column).to eq :age
    end
    it 'returns the method as a symbol if the aggregation function is not present' do
      column = build :column, method: 'age'
      expect(column.db_column).to eq :age
    end
    it 'returns nil if the column has no method' do
      column = build :column
      expect(column.db_column).to eq nil
    end
  end

  describe '#aggregation_keys' do
    it 'returns a list of keys of the different aggregation functions available' do
      expect(Riews::Column.aggregation_keys).to contain_exactly *(0..5).to_a
    end
  end

  describe '#function_names' do
    it 'returns a hash with the function code as key, and the uppercase name as value' do
      expect(Riews::Column.function_names).to eq ({
          0 => 'GROUP',
          1 => 'SUM',
          2 => 'MAX',
          3 => 'MIN',
          4 => 'AVG',
          5 => 'COUNT'
      })
    end
  end

  describe '#functions_info' do
    it 'should be private' do
      expect(Riews::Column.private_methods).to include :functions_info
    end
  end

  describe '#functions' do
    it 'returns a hash with the column name as a downcased symbol and the code as the value' do
      expect(Riews::Column.functions).to eq ({group: 0, sum: 1, max: 2, min: 3, avg: 4, count: 5})
    end
  end
end
