class AddIndexToLikeablesInLikes < ActiveRecord::Migration[5.1]
  def change
    add_index :likes, [:likeable_id, :likeable_type]
  end
end
