module Riews
  class ActionLink < ApplicationRecord
    belongs_to :riews_column, class_name: 'Riews::Column'
    alias_method :column, :riews_column
  end
end
