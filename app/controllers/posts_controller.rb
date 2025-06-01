class PostsController < ApplicationController
  before_action :require_login, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

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
    @user_liked = current_user && @post.likes.exists?(user_id: current_user.id)
    
    @bookmark_count = Bookmark.where(post_id: @post.id).count
    @comments = @post.comments.where(parent_comment_id: nil).includes(:user)
    
    if current_user
      @liked_comment_ids = current_user.likes.where(likeable_type: "Comment", likeable_id: @comments.map(&:id)).pluck(:likeable_id)
    else
      @liked_comment_ids = []
    end
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

  def destroy
    @post.destroy
    redirect_to root_path, notice: "Post was successfully deleted."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    unless @post.user == current_user
      render "errors/forbidden", status: :forbidden
    end
  end

  def post_params
    params.require(:post).permit(:title, :content, :image_url)
  end
end
