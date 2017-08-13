module Riews
  class Column < ApplicationRecord
    belongs_to :riews_view, class_name: 'Riews::View'
    alias_method :view, :riews_view
    delegate :available_columns, to: :view

    validates_presence_of :view
    validates :method, presence: true, inclusion:  {in: proc{ |view| view.available_columns }}

    def format(value)
      "#{prefix}#{value}#{postfix}"
    end
  end
end
