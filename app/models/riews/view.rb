module Riews
  class View < ApplicationRecord
    has_many :columns, -> { order(position: :asc) }, foreign_key: 'riews_view_id', dependent: :destroy
    has_many :filter_criterias, -> { order(position: :asc) }, foreign_key: 'riews_view_id', dependent: :destroy
    has_many :relationships, -> { order(position: :asc) }, foreign_key: 'riews_view_id', dependent: :destroy

    accepts_nested_attributes_for :columns, :filter_criterias, :relationships, reject_if: :all_blank, allow_destroy: true

    validate :model_is_activerecord_class
    validates :code, presence: true, uniqueness: true
    validates :name, presence: true
    validates :paginator_size, :numericality => { :greater_than_or_equal_to => 0 }

    before_create :set_default_values

    def results(page, per_page, ability=nil)
      query = ability ? klass.accessible_by(ability) : klass.all
      query = paginate(query, page, per_page) if per_page > 0
      query = join_relationships query
      query = filter_results query
      query = group_query query
      uniqueness? ? query.distinct : query
    end

    def self.available_models
      ActiveRecord::Base.connection.tables.map{|x|x.classify.safe_constantize}.compact.map(&:name)
    end

    def available_reflections
      return [] unless model
      klass.reflections.keys
    end
    
    def available_columns
      in_table_columns = klass.attribute_names

      in_relationships_columns = klass.reflections
                                     .select{|k, _| relationships.pluck(:name).include? k}
                                     .values
                                     .map(&:klass)
                                     .map{|klass| klass.attribute_names
                                                      .map{|attribute| [klass.table_name, attribute].join('.')}}.flatten

      in_table_columns + in_relationships_columns
    end

    def model_is_activerecord_class
      if model.present?
        errors.add(:model, 'Invalid model!') unless model.constantize.ancestors.include? ActiveRecord::Base
      end
    end

    def klass
      model.constantize
    end

    def queried_column_db_identifiers
      columns.with_method.map(&:db_column)
    end

    private

    def paginate(query, page, per_page)
      query = query.page(page)
      query.per(per_page)
    end

    def filter_results(original_query)
      filter_criterias.inject(original_query){|composed_query, filter| filter.apply_to composed_query }
    end

    def join_relationships(original_query)
      original_query.joins relationships.pluck(:name).map(&:to_sym)
    end

    def set_default_values
      self.name = self.code
    end

    def group_query(query)
      query.group(columns.select{|c| c.aggregate == 0}.map(&:method))
    end
  end
end
