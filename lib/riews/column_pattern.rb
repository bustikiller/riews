require 'dentaku'

module Riews
  class ColumnPattern

    def initialize(pattern)
      @pattern = pattern
    end

    def format(row)
      replacement_patterns = row.map{|k, v| ["[[column:#{k}]]", v]}.to_h
      replaced_value = replacement_patterns.inject(@pattern){|acc, (key, replacement)| acc.gsub(key, replacement.to_s)}
      self.class.apply_math_operations replaced_value
    end

    private

    def self.apply_math_operations(raw_value)
      raw_value.gsub(/\[\[calc:\((.+?)\)\]\]/) do
        expression = Regexp.last_match[1]
        Dentaku::Calculator.new.evaluate(expression)
      end
    rescue StandardError
      '[MATH ERROR]'
    end
  end
end