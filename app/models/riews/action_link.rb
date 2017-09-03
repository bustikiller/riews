module Riews
  class ActionLink < ApplicationRecord
    belongs_to :riews_column, class_name: 'Riews::Column'
    alias_method :column, :riews_column

    has_many :arguments, as: :argumentable, dependent: :destroy
    accepts_nested_attributes_for :arguments, reject_if: :all_blank, allow_destroy: true

  end
end
