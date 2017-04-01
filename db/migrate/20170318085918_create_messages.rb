class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :body
      t.belongs_to :sender, :class_name => 'ChatUser'
      t.belongs_to :receiver, :class_name => 'ChatUser'

      t.timestamps
    end
  end
end
