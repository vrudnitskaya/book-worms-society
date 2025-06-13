class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @followers = @user.followers
    @following = @user.followed_users
    @followers_count = @followers.count
    @following_count = @following.count
    @recent_posts = @user.posts.order(created_at: :desc).limit(3)
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to @user, notice: "The profile has been updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    redirect_to login_path, alert: "Access denied." unless current_user == @user
  end

  def user_params
    params.require(:user).permit(:username, :email, :bio, :avatar_url, :password, :password_confirmation)
  end
end