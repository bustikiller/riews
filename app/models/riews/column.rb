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
    validates :method, allow_nil: true,
              inclusion:  {in: proc{ |column| column.available_columns }},
              unless: proc{ |column| column.pattern.present? }
    validates :aggregate, inclusion: { in: aggregation_functions.keys + [nil] }
    validate :method_xor_pattern

    scope :with_method, -> { where.not method: nil }

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

    def replacement_info
      { description: "Value of the column \"#{displayed_name}\"" }
    end

    def replacement_tokens
      view.columns
          .with_method
          .map{ |column| { "[[column:#{column.id}]]" => column.replacement_info }}
          .inject(:merge) || {}
    end

    private

    def method_xor_pattern
      unless method.blank? ^ pattern.blank?
        errors.add(:base, 'Specify a method or a pattern, not both')
      end
    end
  end
end
