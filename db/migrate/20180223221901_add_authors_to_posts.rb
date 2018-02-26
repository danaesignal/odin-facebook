class AddAuthorsToPosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :author, foreign_key: { to_table: :users}
  end
end
