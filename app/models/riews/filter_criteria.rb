module Riews
  class FilterCriteria < ApplicationRecord
    self.table_name = 'riews_filter_criterias'

    def self.operators
      {
          1 => 'NULL',
          2 => 'NOT NULL',
          3 => '=',
          4 => 'IN'
      }
    end

    belongs_to :riews_view, class_name: 'Riews::View'
    has_many :arguments, foreign_key: 'riews_filter_criteria_id', dependent: :delete_all, inverse_of: :riews_filter_criteria
    accepts_nested_attributes_for :arguments, reject_if: :all_blank, allow_destroy: true

    alias_method :view, :riews_view

    validates :operator, inclusion: { in: operators.keys }
    validates_presence_of :view, :field_name, :operator

    def available_filter_criterias
      (view.model.constantize).attribute_names
    end

    def apply_to(query)
      case operator
        when 1
          query.where(field_name => nil)
        when 2
          query.where.not(field_name => nil)
        when 3, 4
          query.where(field_name => arguments.pluck(:value))
        else
          query
      end
    end
  end
end
