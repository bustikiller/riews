module Riews
  class FilterCriteria < ApplicationRecord
    self.table_name = 'riews_filter_criterias'

    def self.operators
      {
          1 => 'NULL',
          2 => 'NOT NULL'
      }
    end

    belongs_to :riews_view, class_name: 'Riews::View'
    alias_method :view, :riews_view

    validates :operator, inclusion: { in: operators.keys }
    validates_presence_of :view, :field_name, :operator

    def available_filter_criterias
      (view.model.constantize).attribute_names
    end

  end
end
