class LikesController < ApplicationController
  include LikesHelper

  def create
    current_user.likes << likeable_content.likes.build unless already_liked?
    redirect_back(fallback_location: root_path)
  end

  def destroy
    Like.destroy(params[:id])
    redirect_back(fallback_location: root_path)
  end
end
