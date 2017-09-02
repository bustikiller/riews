module Riews
  class ActionLink < ApplicationRecord
    # self.table_name = 'riews_action_links'

    belongs_to :riews_column, class_name: 'Riews::Column'
    alias_method :column, :riews_column


  end
end
