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
        when 5
          query.where("#{field_name} LIKE ?", "#{arguments.first.value}") if arguments.any?
        when 6
          query.where(field_name => (arguments.first.value..arguments.last.value)) if arguments.count == 2
        when 7
          query.where("#{field_name} > ?", "#{arguments.first.value}") if arguments.count == 1
        when 8
          query.where("#{field_name} >= ?", "#{arguments.first.value}") if arguments.count == 1
        when 9
          query.where("#{field_name} < ?", "#{arguments.first.value}") if arguments.count == 1
        when 10
          query.where("#{field_name} <= ?", "#{arguments.first.value}") if arguments.count == 1
        when 11
          query.where("#{field_name} REGEXP ?", "#{arguments.first.value}") if arguments.count == 1
        else
          query
      end
    end
  end
end
