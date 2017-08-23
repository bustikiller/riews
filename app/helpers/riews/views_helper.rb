require 'riews/column_pattern'

module Riews
  module ViewsHelper
    def generate_view_content_for(view, page=1)
      bootstrap_table do |table|
        table.headers = view.columns.displayed.map(&:displayed_name)
        table.rows = render_view_rows(page, view)
      end
    end

    def generate_view_paginator_for(view, page=1)
      paginate get_affected_models(view, page) if view.columns.any? && view.paginator_size > 0
    end

    def generate_helper_buttons_for(view)
      [
          link_to('Edit', riews.edit_view_path(view)),
          link_to('All views', riews.views_path),
      ].inject{|sum, link| sum +' | ' + link }
    end

    def generate_raw_sql_for(view, page=1)
      sql_statement = get_affected_models(view, page).select(*view.queried_column_db_identifiers).to_sql
      content_tag :code, sql_statement, class: 'col-md-12'
    end

    def riews_table_with_code(code)
      riews_table(View.find_or_create_by code: code)
    end

    def riews_table(view, page=1)
      if view.model.present? && view.columns.any?
        [
            generate_view_content_for(view, page),
            generate_view_paginator_for(view, page),
            generate_raw_sql_for(view, page),
            generate_helper_buttons_for(view)
        ].compact.inject(:+)
      else
        render partial: 'riews/views/empty_view', locals: {view: view}
      end
    end

    def available_columns_for_select(view)
      view.available_columns.group_by{|c| c.split('.').size > 1 ? c.split('.').first : view.klass.table_name}
    end

    private

    def get_affected_models(view, page)
      view.results(page, view.paginator_size)
    end

    def render_view_rows(page, view)
      columns_queried = view.columns.with_method
      rows = get_affected_models(view, page).pluck(*view.queried_column_db_identifiers)
      rows.map do |row|
        row_with_context = row.each_with_index.map{ |value, i| { columns_queried[i].id => value } }.inject({}, :merge)
        render_single_row(view.columns, row_with_context)
      end
    end

    def render_single_row(columns, row)
      original_row = row.dup
      columns.displayed.map do |column|
        if column.method.present? then
          column.format(row.shift.last)
        else
          Riews::ColumnPattern.new(column.pattern).format(original_row)
        end
      end
    end
  end
end
