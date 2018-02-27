class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order('created_at DESC')
  end

  def index
    @posts = current_user.posts.order('created_at DESC')
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = "Post created!"
      redirect_to posts_path
    else
      flash[:alert].now = "There was a problem!"
      render 'index'
    end
  end

  private

  def post_params
    params.require(:post).permit(:author_id, :content)
  end
end
