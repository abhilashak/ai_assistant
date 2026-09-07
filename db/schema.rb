# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_06_073053) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ai_requests", force: :cascade do |t|
    t.datetime "completed_at"
    t.bigint "conversation_id"
    t.datetime "created_at", null: false
    t.string "error_class"
    t.text "error_message"
    t.decimal "estimated_cost", precision: 12, scale: 8
    t.integer "http_status"
    t.integer "input_tokens"
    t.integer "latency_ms"
    t.bigint "message_id"
    t.jsonb "metadata", default: {}, null: false
    t.string "model", null: false
    t.string "operation", null: false
    t.integer "output_tokens"
    t.string "provider", null: false
    t.string "request_id"
    t.integer "retry_count", default: 0, null: false
    t.datetime "started_at"
    t.string "status", null: false
    t.boolean "streamed", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_ai_requests_on_conversation_id"
    t.index ["created_at"], name: "index_ai_requests_on_created_at"
    t.index ["message_id"], name: "index_ai_requests_on_message_id"
    t.index ["model"], name: "index_ai_requests_on_model"
    t.index ["provider"], name: "index_ai_requests_on_provider"
    t.index ["request_id"], name: "index_ai_requests_on_request_id", unique: true
    t.index ["status"], name: "index_ai_requests_on_status"
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.integer "input_tokens"
    t.string "model"
    t.integer "output_tokens"
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.check_constraint "role::text = ANY (ARRAY['user'::character varying, 'assistant'::character varying, 'system'::character varying]::text[])", name: "messages_role_check"
  end

  add_foreign_key "ai_requests", "conversations"
  add_foreign_key "ai_requests", "messages"
  add_foreign_key "messages", "conversations"
end
