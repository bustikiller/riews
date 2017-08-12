module Riews
  class View < ApplicationRecord
    has_many :columns, foreign_key: 'riews_view_id'
    accepts_nested_attributes_for :columns

    validates :model, presence: true, inclusion: { in: ActiveRecord::Base.descendants.map(&:name) }
    validates :code, presence: true, uniqueness: true
    validates :name, presence: true

    def results
      model.constantize.all
    end

    def self.available_models
      ActiveRecord::Base.descendants.map(&:name)
    end
  end
end
