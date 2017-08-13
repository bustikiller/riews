class AddPrefixAndPostfixToColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :riews_columns, :prefix, :string
    add_column :riews_columns, :postfix, :string
  end
end
