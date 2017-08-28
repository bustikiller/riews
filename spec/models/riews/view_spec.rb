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

  describe '#klass' do
    it 'returns the class of the model the view is associated to' do
      view = build :view, model: 'Object'
      expect(view.klass).to eq Object
    end
  end

  describe '#group_query' do
    let(:view) do
      view = build :view
      allow(view).to receive(:available_columns){%w(lorem ipsum)}
      view.save validate: false
      view
    end
    let(:query) do
      query = Object.new
      allow(query).to receive(:group)
      query
    end
    it 'calls the ActiveRecord::Relation method #group with the columns with GROUP aggregation' do
      create :column, view: view, method: 'lorem', aggregate: Riews::Column.functions[:group]
      create :column, view: view, method: 'ipsum', aggregate: Riews::Column.functions[:group]

      expect(query).to receive(:group).with(%w(lorem ipsum))
      view.send :group_query, query
    end

    it 'excludes the columns that do not have GROUP aggregation' do
      create :column, view: view, method: 'lorem', aggregate: Riews::Column.functions[:group]
      create :column, view: view, method: 'ipsum', aggregate: Riews::Column.functions[:max]

      expect(query).to receive(:group).with(['lorem'])
      view.send :group_query, query
    end
  end

  describe '#join_relationships' do
    it 'calls the ActiveRecord::Relation method #joins with the names of the associations chosen' do
      view = create :view
      allow(view).to receive(:available_reflections){ %w(foo bar) }
      create :relationship, view: view, name: 'foo'
      create :relationship, view: view, name: 'bar'

      query = Object.new
      allow(query).to receive(:joins)

      expect(query).to receive(:joins).with([:foo, :bar])
      view.send :join_relationships, query
    end
  end

  describe '#queried_columns_db_identifiers' do
    it 'returms an empty list if the view has no columns' do
      expect(build(:view).queried_column_db_identifiers).to be_empty
    end
    it 'returns an empty view if no column has method' do
      view = create :view
      create :column, view: view, method: nil, pattern: 'whatever'
      expect(view.queried_column_db_identifiers).to be_empty
    end
    it 'returns a list of strings with the result of calling db_column on the columns with method' do
      view = create :view
      allow(view).to receive(:available_columns){ %w(foo bar) }
      create :column, view: view, method: nil, pattern: 'foo'
      create :column, view: view, method: 'bar'
      expect(view.queried_column_db_identifiers).to contain_exactly :bar
    end
  end
end
