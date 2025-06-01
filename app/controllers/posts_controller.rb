class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update]
  before_action :set_post, only: [:show, :edit, :update]
  before_action :authorize_user!, only: [:edit, :update]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @tags = @post.tags
    @like_count = @post.likes.count
    @bookmark_count = Bookmark.where(post_id: @post.id).count
    @comments = @post.comments.where(parent_comment_id: nil).includes(:user)
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    unless @post.user == current_user
      redirect_to @post, alert: "You have no permission to edit this post."
    end
  end

  def post_params
    params.require(:post).permit(:title, :content, :image_url)
  end
end
