class CreateRiewsViews < ActiveRecord::Migration[5.1]
  def change
    create_table :riews_views do |t|
      t.string :name, null: false
      t.string :model, null: false
      t.string :code, unique: true, null: false

      t.timestamps
    end
  end
end
