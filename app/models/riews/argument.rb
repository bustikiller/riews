module Riews
  class Argument < ApplicationRecord
    belongs_to :riews_filter_criteria, class_name: 'Riews::FilterCriteria'
    alias_method :filter_criteria, :riews_filter_criteria

    validates_presence_of :filter_criteria
    validates :value, presence: true
  end
end
