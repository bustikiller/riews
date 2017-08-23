class AddHideFromDisplayToColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :riews_columns, :hide_from_display, :boolean, default: false
  end
end
