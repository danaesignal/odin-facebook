class AddUsersToFriendships < ActiveRecord::Migration[5.1]
  def change
    add_column :friendships, :initiator_id, :integer
    add_column :friendships, :recipient_id, :integer

    add_index :friendships, :initiator_id
    add_index :friendships, :recipient_id
  end
end
