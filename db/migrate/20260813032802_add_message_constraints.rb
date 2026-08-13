class AddMessageConstraints < ActiveRecord::Migration[8.1]
  def change
    change_column_null :messages, :role, false
    change_column_null :messages, :content, false

    add_check_constraint(
      :messages,
      "role IN ('user', 'assistant', 'system')",
      name: "messages_role_check"
    )
  end
end
