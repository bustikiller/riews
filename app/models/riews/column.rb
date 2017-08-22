module Riews
  class Column < ApplicationRecord

    def self.aggregation_functions
      {
          0 => 'GROUP',
          1 => 'SUM',
          2 => 'MAX',
          3 => 'MIN',
          4 => 'AVG',
          5 => 'COUNT'
      }
    end

    belongs_to :riews_view, class_name: 'Riews::View'
    alias_method :view, :riews_view
    alias_method :view=, :riews_view=
    delegate :available_columns, to: :view

    validates_presence_of :view
    validates :method, presence: true, inclusion:  {in: proc{ |view| view.available_columns }}
    validates :aggregate, inclusion: { in: aggregation_functions.keys + [nil] }

    def format(value)
      "#{prefix}#{value}#{postfix}"
    end

    def db_column
      case aggregate
        when 1
          "SUM(#{method})"
        when 2
          "MAX(#{method})"
        when 3
          "MIN(#{method})"
        when 4
          "AVG(#{method})"
        when 5
          'COUNT(*)'
        else
          method.to_sym
      end
    end

    def displayed_name
      name.present? ? name : db_column
    end
  end
end
