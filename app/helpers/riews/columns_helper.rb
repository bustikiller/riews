module Riews
  module ColumnsHelper
    def aggregation_functions_for_select
      Riews::Column.aggregation_functions.to_a
    end

    def format_replacement_tokens(tokens)
      content_tag :ul do
        tokens.map do |k, v|
          content_tag :li, "#{k} -> #{v[:description]}"
        end.inject(:+)
      end
    end
  end
end
