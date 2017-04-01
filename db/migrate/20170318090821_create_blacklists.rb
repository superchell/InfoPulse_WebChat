class CreateBlacklists < ActiveRecord::Migration[5.0]
  def change
    create_table :blacklists do |t|
      t.belongs_to :user, :class_name => 'ChatUser'
      t.timestamps
    end
  end
end
