# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170903000002) do

  create_table "riews_action_links", force: :cascade do |t|
    t.string "base_path"
    t.string "display_pattern"
    t.integer "riews_column_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "http_verb", limit: 1, default: 0, null: false
    t.index ["riews_column_id"], name: "index_riews_action_links_on_riews_column_id"
  end

  create_table "riews_arguments", force: :cascade do |t|
    t.string "value", null: false
    t.integer "argumentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0, null: false
    t.string "argumentable_type"
    t.index ["argumentable_id"], name: "index_riews_arguments_on_argumentable_id"
  end

  create_table "riews_columns", force: :cascade do |t|
    t.string "method"
    t.integer "riews_view_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prefix"
    t.string "postfix"
    t.integer "aggregate", limit: 2
    t.string "name"
    t.string "pattern"
    t.boolean "hide_from_display", default: false
    t.integer "position", default: 0, null: false
    t.index ["riews_view_id"], name: "index_riews_columns_on_riews_view_id"
  end

  create_table "riews_filter_criterias", force: :cascade do |t|
    t.string "field_name"
    t.integer "operator", limit: 2, null: false
    t.integer "riews_view_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "negation", default: false, null: false
    t.integer "position", default: 0, null: false
    t.index ["riews_view_id"], name: "index_riews_filter_criterias_on_riews_view_id"
  end

  create_table "riews_relationships", force: :cascade do |t|
    t.string "name"
    t.integer "riews_view_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0, null: false
    t.index ["riews_view_id"], name: "index_riews_relationships_on_riews_view_id"
  end

  create_table "riews_views", force: :cascade do |t|
    t.string "name", null: false
    t.string "model"
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "paginator_size", default: 0, null: false
    t.boolean "uniqueness", default: false, null: false
  end

end
