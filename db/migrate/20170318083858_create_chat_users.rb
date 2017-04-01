class CreateChatUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_users do |t|
      t.string :name
      t.string :login, unique: true
      t.string :password
      t.belongs_to :role, :class_name => 'Role'
    end

    add_index :chat_users, :login, unique: true

  end
end
