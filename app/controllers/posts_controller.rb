class PostsController < ApplicationController
  before_action :set_post, only: [ :show, :edit, :update ]

  def new
    @post = Post.new
  end

  # we temporary use the random user to create the post
  def create
    random_user = User.order("RANDOM()").first

    unless random_user
      redirect_to root_path, alert: "No users found to assign this post."
      return
    end

    @post = Post.new(post_params)
    @post.user = random_user

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new
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
      render :edit
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :image_url)
  end
end
