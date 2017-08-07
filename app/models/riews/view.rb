module Riews
  class View < ApplicationRecord
    def columns
      model.constantize.attribute_names
    end

    def results
      model.constantize.all
    end
  end
end
