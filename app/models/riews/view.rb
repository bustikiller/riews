module Riews
  class View < ApplicationRecord
    has_many :columns, foreign_key: 'riews_view_id'
    accepts_nested_attributes_for :columns

    validates :model, inclusion: { in: ActiveRecord::Base.descendants.map(&:name) }

    def results
      model.constantize.all
    end
  end
end
