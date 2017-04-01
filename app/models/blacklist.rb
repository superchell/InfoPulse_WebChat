class Blacklist < ApplicationRecord
  belongs_to :user, :class_name => 'ChatUser', foreign_key: 'user_id'

end
