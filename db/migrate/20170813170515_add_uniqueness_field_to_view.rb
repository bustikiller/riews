class AddUniquenessFieldToView < ActiveRecord::Migration[5.1]
  def change
    add_column :riews_views, :uniqueness, :boolean, default: false, null: false
  end
end
