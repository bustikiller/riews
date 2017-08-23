module Riews
  class ColumnPattern

    def initialize(pattern)
      @pattern = pattern
    end

    def format(row)
      replacement_patterns = row.map{|k, v| ["[[column:#{k}]]", v]}.to_h
      replacement_patterns.inject(@pattern){|acc, (key, replacement)| acc.gsub(key, replacement.to_s)}
    end
  end
end