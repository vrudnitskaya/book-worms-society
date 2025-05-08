class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @followers = @user.followers
    @following = @user.followed_users
    @followers_count = @followers.count
    @following_count = @following.count
  end
end
