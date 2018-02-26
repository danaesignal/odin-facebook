class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.order('created_at DESC')
  end

  def index
    @users = User.paginate(page: params[:page])
  end
end
