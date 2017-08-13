module Riews
  class FilterCriteria < ApplicationRecord
    self.table_name = 'riews_filter_criterias'

    def self.operators
      {
          1 => 'NULL',
          2 => 'NOT NULL',
          3 => '=',
          4 => 'IN',
          5 => 'LIKE',
          6 => 'BETWEEN',
          7 => '>',
          8 => '>=',
          9 => '<',
          10 => '<=',
          11 => 'REGEXP'
      }
    end

    belongs_to :riews_view, class_name: 'Riews::View'
    has_many :arguments, foreign_key: 'riews_filter_criteria_id', dependent: :destroy, inverse_of: :riews_filter_criteria
    accepts_nested_attributes_for :arguments, reject_if: :all_blank, allow_destroy: true

    alias_method :view, :riews_view
    delegate :available_columns, to: :view

    validates :operator, inclusion: { in: operators.keys }
    validates_presence_of :view, :field_name, :operator

    def apply_to(query)
      query_modifier = case operator
                         when 1
                           {field_name => nil}
                         when 2
                           ["#{field_name} IS NOT NULL"]
                         when 3, 4
                           {field_name => arguments.pluck(:value)}
                         when 5
                           ["#{field_name} LIKE ?", "#{arguments.first.value}"] if arguments.any?
                         when 6
                           {field_name => (arguments.first.value..arguments.last.value)} if arguments.count == 2
                         when 7
                           ["#{field_name} > ?", "#{arguments.first.value}"] if arguments.count == 1
                         when 8
                           ["#{field_name} >= ?", "#{arguments.first.value}"] if arguments.count == 1
                         when 9
                           ["#{field_name} < ?", "#{arguments.first.value}"] if arguments.count == 1
                         when 10
                           ["#{field_name} <= ?", "#{arguments.first.value}"] if arguments.count == 1
                         when 11
                           ["#{field_name} REGEXP ?", "#{arguments.first.value}"] if arguments.count == 1
                         else
                           nil
                       end
      negation? ? query.where.not(query_modifier) : query.where(query_modifier)
    end
  end
end
