class AddActivationToFriendships < ActiveRecord::Migration[5.1]
  def change
    add_column :friendships, :activated, :boolean
  end
end
