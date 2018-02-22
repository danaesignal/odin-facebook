module UsersHelper
  def hide_button
    current_user.friends?(@user) or current_user.pending_friends?(@user) or
      current_user == @user
  end
end
