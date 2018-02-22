class Friendship < ApplicationRecord
  belongs_to :initiator, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  def accept_friend_request
    update_attributes(activated: true)
  end
end
