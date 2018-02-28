class CommentsController < ApplicationController
  def create
    @post = Post.find(comment_params[:post_id])
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:notice] = "Comment posted!"
      redirect_back(fallback_location: @post)
    else
      flash[:alert].now = "There was a problem!"
      render @post
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:author_id, :post_id, :content)
  end
end
