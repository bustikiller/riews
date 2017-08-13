module Riews
  module ColumnsHelper
    def aggregation_functions_for_select
      Riews::Column.aggregation_functions.to_a
    end
  end
end
