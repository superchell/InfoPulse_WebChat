class ChatUser < ApplicationRecord
  belongs_to :role, :class_name => 'Role', foreign_key: 'role_id'
  validates :login, uniqueness: true

  before_validation :default_save

  def default_save
    self.role_id = 1
  end

end
