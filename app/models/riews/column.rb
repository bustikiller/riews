module Riews
  class Column < ApplicationRecord
    belongs_to :riews_view, class_name: 'Riews::View'
    alias_method :view, :riews_view

    validates_presence_of :view
    validates :method, presence: true, inclusion:  {in: proc{ |view| view.available_columns }}

    def available_columns
      in_table_columns = (view.klass).attribute_names

      in_relationships_columns = view.klass.reflections
                            .select{|k, _| view.relationships.pluck(:name).include? k}
                            .values
                            .map(&:klass)
                            .map{|klass| klass.attribute_names
                                             .map{|attribute| [klass.table_name, attribute].join('.')}}.flatten

      in_table_columns + in_relationships_columns
    end
  end
end
