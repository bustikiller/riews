module Riews
  module OperatorsHelper
    def operators_for_select
      Riews::FilterCriteria.operators.to_a
    end
  end
end
