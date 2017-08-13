module Riews
  module ViewsHelper
    def generate_view_content_for(view, page=1)
      bootstrap_table do |table|
        table.headers = view.columns.map(&:method)
        table.rows = render_view_rows(page, view)
      end
    end

    def generate_view_paginator_for(view, page=1)
      paginate get_affected_models(view, page) if view.columns.any?
    end

    def generate_helper_buttons_for(view)
      [
          link_to('Edit', riews.edit_view_path(view)),
          link_to('All views', riews.views_path),
      ].inject{|sum, link| sum +' | ' + link }
    end

    def riews_table_with_code(code)
      riews_table(View.find_or_create_by code: code)
    end

    def riews_table(view, page=1)
      if view.model.present? && view.columns.any?
        [
            generate_view_content_for(view, page),
            generate_view_paginator_for(view, page),
            generate_helper_buttons_for(view)
        ].compact.inject(:+)
      else
        render partial: 'riews/views/empty_view', locals: {view: view}
      end
    end

    private

    def get_affected_models(view, page)
      view.results(page, view.paginator_size)
    end

    def render_view_rows(page, view)
      rows = get_affected_models(view, page).pluck(*view.columns.map(&:method).map(&:to_sym))
      rows.map! do |row|
        row.each_with_index.map{|cell, i| view.columns[i].format cell }
      end
      rows
    end
  end
end
