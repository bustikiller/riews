module Riews
  class Argument < ApplicationRecord
    belongs_to :argumentable, polymorphic: true
    delegate :view, to: :argumentable

    validates_presence_of :argumentable
    validates :value, presence: true
  end
end
