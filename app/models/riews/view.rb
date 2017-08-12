module Riews
  class View < ApplicationRecord
    has_many :columns, foreign_key: 'riews_view_id', dependent: :delete_all
    has_many :filter_criterias, foreign_key: 'riews_view_id', dependent: :delete_all

    accepts_nested_attributes_for :columns, :filter_criterias

    validates :model, presence: true
    validate :model_is_activerecord_class
    validates :code, presence: true, uniqueness: true
    validates :name, presence: true
    validates :paginator_size, :numericality => { :greater_than_or_equal_to => 0 }

    def results(page, per_page)
      query = model.constantize.all.page(page)
      query = query.per(per_page) if per_page > 0
      query
    end

    def self.available_models
      ActiveRecord::Base.descendants.map(&:name)
    end

    def model_is_activerecord_class
      if model.present?
        errors.add(:model, 'Invalid model!') unless model.constantize.ancestors.include? ActiveRecord::Base
      end
    end
  end
end
