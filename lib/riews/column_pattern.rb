module Riews
  class ColumnPattern

    def initialize(pattern)
      @pattern = pattern
    end

    def format(row)
      @pattern
    end
  end
end