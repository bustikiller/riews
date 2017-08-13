module Riews
  module ViewsHelper
    def generate_view_content_for(view, page=1)
      if view.columns.any?
        bootstrap_table do |table|
          table.headers = view.columns.map(&:method)
          table.rows = get_affected_models(view, page).pluck(*view.columns.map(&:method).map(&:to_sym))
        end
      end
    end

    def generate_view_paginator_for(view, page=1)
      paginate get_affected_models(view, page)
    end

    private

    def get_affected_models(view, page)
      view.results(page, view.paginator_size)
    end
  end
end
