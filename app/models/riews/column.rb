module Riews
  class Column < ApplicationRecord

    has_many :action_links, foreign_key: 'riews_column_id', dependent: :destroy, inverse_of: :riews_column
    accepts_nested_attributes_for :action_links, reject_if: :all_blank, allow_destroy: true

    def self.functions_info
      {
          group: { code: 0, name: 'GROUP', function: Proc.new { |column| column } },
          sum:   { code: 1, name: 'SUM'  , function: Proc.new { |column| "SUM(#{column})" } },
          max:   { code: 2, name: 'MAX'  , function: Proc.new { |column| "MAX(#{column})" } },
          min:   { code: 3, name: 'MIN'  , function: Proc.new { |column| "MIN(#{column})" } },
          avg:   { code: 4, name: 'AVG'  , function: Proc.new { |column| "AVG(#{column})" } },
          count: { code: 5, name: 'COUNT', function: Proc.new { |_| 'COUNT(*)'} },
      }
    end
    private_class_method :functions_info

    def self.functions
      functions_info.values.map{|pair| {pair[:name].downcase.to_sym => pair[:code]}}.inject(:merge)
    end

    def self.aggregation_keys
      functions.values
    end

    def self.function_names
      functions_info.values.map{|info| [info[:code], info[:name]]}.to_h
    end

    def self.function_lambdas
      functions_info.values.map{|info| [info[:code], info[:function]]}.to_h
    end

    belongs_to :riews_view, class_name: 'Riews::View'
    alias_method :view, :riews_view
    alias_method :view=, :riews_view=
    delegate :available_columns, to: :view

    validates_presence_of :view
    validates :method, inclusion:  {in: proc{ |column| column.available_columns }}, allow_blank: true
    validates :aggregate, inclusion: { in: aggregation_keys }, allow_nil: true
    validate :column_with_single_purpose

    scope :with_method, -> { where.not method: [nil, ''] }
    scope :displayed, -> { where hide_from_display: false }

    def format(value)
      "#{prefix}#{value}#{postfix}"
    end

    def db_column
      return nil unless method.present?
      return method.to_sym unless self.class.aggregation_keys.include?(aggregate)
      self.class.function_lambdas[aggregate].call(method)
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

    def column_with_single_purpose
      method_column = method.present?
      pattern_column = pattern.present?
      links_column = action_links.reject(&:marked_for_destruction?).size != 0

      purposes = [method_column, pattern_column, links_column]
      if purposes.combination(2).any?{ |combination| combination.inject(:&) }
        errors.add(:base, 'A single column can only have a method, a pattern, or links')
      end
    end
  end
end
