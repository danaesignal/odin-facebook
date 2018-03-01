module UsersHelper
  def hide_button
    current_user.friends?(@user) or current_user.pending_friends?(@user) or
      current_user == @user
  end

  def sub_headline
    sub_header = "#{@user.job}"
    sub_header += " from " unless (@user.city.blank? && @user.state.blank?)
    sub_header += "#{@user.city}, " unless @user.city.blank?
    sub_header += "#{@user.state}" unless @user.state.blank?
    return sub_header
  end
end
