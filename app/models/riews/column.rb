module Riews
  class Column < ApplicationRecord

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
    validates :method, allow_nil: true,
              inclusion:  {in: proc{ |column| column.available_columns }},
              unless: proc{ |column| column.pattern.present? }
    validates :aggregate, inclusion: { in: aggregation_keys + [nil] }
    validate :method_xor_pattern

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

    def method_xor_pattern
      unless method.blank? ^ pattern.blank?
        errors.add(:base, 'Specify a method or a pattern, not both')
      end
    end
  end
end
