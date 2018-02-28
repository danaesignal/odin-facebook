module LikesHelper
  def likeable_content
    content_type = params[:content_type].downcase
    content_id = params[:content_id]

    content_type == "post" ? Post.find(content_id) : Comment.find(content_id)
  end

  def already_liked?
    current_user.liked_content.include? likeable_content
  end

  def unlike(content)
    return unless current_user.liked_content.include? content
    content.likes.where(user_id: current_user.id).first.delete
  end

  def like_record_for(content)
    current_user.likes.where(likeable_type: "#{content.class}", likeable_id: content.id).first
  end
end
