module Riews
  class View < ApplicationRecord
    has_many :columns, foreign_key: 'riews_view_id', dependent: :delete_all
    accepts_nested_attributes_for :columns

    validates :model, presence: true
    validate :model_is_activerecord_class
    validates :code, presence: true, uniqueness: true
    validates :name, presence: true

    def results
      model.constantize.all
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
