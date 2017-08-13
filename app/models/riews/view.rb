module Riews
  class View < ApplicationRecord
    has_many :columns, foreign_key: 'riews_view_id', dependent: :delete_all
    has_many :filter_criterias, foreign_key: 'riews_view_id', dependent: :delete_all
    has_many :relationships, foreign_key: 'riews_view_id', dependent: :delete_all

    accepts_nested_attributes_for :columns, :filter_criterias, :relationships

    validates :model, presence: true
    validate :model_is_activerecord_class
    validates :code, presence: true, uniqueness: true
    validates :name, presence: true
    validates :paginator_size, :numericality => { :greater_than_or_equal_to => 0 }

    def results(page, per_page)
      query = model.constantize.all
      query = query.page(page)
      query = query.per(per_page) if per_page > 0
      query = join_relationships query
      query = filter_results query
    end

    def self.available_models
      ActiveRecord::Base.descendants.map(&:name)
    end

    def model_is_activerecord_class
      if model.present?
        errors.add(:model, 'Invalid model!') unless model.constantize.ancestors.include? ActiveRecord::Base
      end
    end

    private

    def filter_results(original_query)
      filter_criterias.inject(original_query){|composed_query, filter| filter.apply_to composed_query }
    end

    def join_relationships(original_query)
      original_query.joins relationships.pluck(:name).map(&:to_sym)
    end
  end
end
