class FriendshipsController < ApplicationController
  def create
    @user = User.find(friendship_params[:recipient_id])
    current_user.passive_friends << @user
    redirect_to @user
  end

  def index
    @friendships = Friendship.where(recipient_id: current_user.id,
      activated: false)
    @friends = current_user.friends
  end

  def update
    @friendship = Friendship.find(params[:id])
    @friendship.activated = true

    if @friendship.save
      flash[:notice] = "#{@friendship.initiator.name} is now your friend!"
    else
      flash[:alert] = "Something went wrong! Please contact an administrator."
    end

    redirect_to friendships_path
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    redirect_to friendships_path
  end

  private

  def friendship_params
    params.require(:friendship).permit(:id, :initiator_id, :recipient_id, :activated)
  end
end
