class FollowsController < ApplicationController
  before_action :require_login

  def create
    followed_user = User.find(params[:followed_user_id])
    current_user.following_relationships.create!(followed_user: followed_user)
    redirect_back(fallback_location: user_path(followed_user), notice: "Started following #{followed_user.username}.")
  end

  def destroy
    followed_user = User.find(params[:id])
    follow = current_user.following_relationships.find_by(followed_user: followed_user)
    follow&.destroy
    redirect_back(fallback_location: user_path(followed_user), notice: "Unfollowed #{followed_user.username}.")
  end
end
