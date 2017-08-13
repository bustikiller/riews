module Riews
  class Relationship < ApplicationRecord
    belongs_to :riews_view, class_name: 'Riews::View'
    alias_method :view, :riews_view

    validates_presence_of :view
    validates :name, presence: true, inclusion: { in: proc{|r| r.view.klass.reflections.keys }}
  end
end
