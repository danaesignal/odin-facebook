class AddDefaultValueForActivatedInFriendships < ActiveRecord::Migration[5.1]
  def change
    change_column :friendships, :activated, :boolean, :default => false
  end
end
