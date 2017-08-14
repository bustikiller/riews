class AddNameToColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :riews_columns, :name, :string
  end
end
