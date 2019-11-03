require 'dentaku'
require 'bh'

module Riews
  class ColumnPattern
    include ActionView::Helpers::SanitizeHelper
    extend ActionView::Helpers::TagHelper
    extend Bh::Helpers

    def initialize(pattern)
      @pattern = pattern
    end

    def format(row)
      replacement_patterns = row.map{|k, v| ["[[column:#{k}]]", v]}.to_h
      replaced_value = replacement_patterns.inject(@pattern){|acc, (key, replacement)| acc.gsub(key, replacement.to_s)}
      replaced_value = self.class.apply_math_operations replaced_value
      self.class.replace_glyphicons replaced_value
    end

    def self.apply_math_operations(raw_value)
      token = /\[\[calc:\((.+?)\)\]\]/
      action = proc{ |match| Dentaku::Calculator.new.evaluate(match) }
      apply_action_on_token(raw_value, token, action).presence || '[MATH ERROR]'
    end

    def self.replace_glyphicons(raw_value)
      token = /\[\[icon:(.+?)\]\]/
      action = proc{ |match| icon match }
      apply_action_on_token(raw_value, token, action).html_safe
    end

    def self.apply_action_on_token(raw_value, token, action)
      (raw_value || '').gsub(token) do
        action.call($1)
      end
    end
  end
end