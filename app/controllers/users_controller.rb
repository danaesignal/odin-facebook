class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts.order('created_at DESC')
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to @user
    else
      redirect_back(fallback_position: @user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :city, :state, :job, :avatar)
  end
end
