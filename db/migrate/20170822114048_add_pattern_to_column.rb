class AddPatternToColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :riews_columns, :pattern, :string
  end
end
