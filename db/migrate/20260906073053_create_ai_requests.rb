class CreateAiRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :ai_requests do |t|
      t.references :conversation, foreign_key: true
      t.references :message, foreign_key: true

      t.string :provider, null: false
      t.string :model, null: false
      t.string :operation, null: false
      t.string :status, null: false

      t.integer :input_tokens
      t.integer :output_tokens

      t.decimal :estimated_cost, precision: 12, scale: 8

      t.integer :latency_ms
      t.integer :retry_count, null: false, default: 0
      t.integer :http_status

      t.string :request_id

      t.string :error_class
      t.text :error_message

      t.datetime :started_at
      t.datetime :completed_at

      t.boolean :streamed, null: false, default: false

      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :ai_requests, :status
    add_index :ai_requests, :provider
    add_index :ai_requests, :model
    add_index :ai_requests, :created_at
    add_index :ai_requests, :request_id, unique: true
  end
end
