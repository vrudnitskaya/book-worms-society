class PostsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @top_tags = Tag.joins(:posts).group(:id).order("COUNT(posts.id) DESC").limit(10)

    per_page = 4
    page = params[:page].to_i
    page = 1 if page < 1
    offset = (page - 1) * per_page

    base_query = if params[:filter] == "following" && current_user
                   followed_ids = current_user.followed_users.pluck(:id)
                   Post.where(user_id: followed_ids)
                 else
                   Post.all
                 end

    @total_posts = base_query.count
    @posts = base_query
             .includes(:user)
             .order(created_at: :desc)
             .limit(per_page)
             .offset(offset)

    @current_page = page
    @total_pages = (@total_posts.to_f / per_page).ceil
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params.except(:new_tags))

    if @post.save
      assign_tags(@post)
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
    @bookmarked = current_user && Bookmark.exists?(user: current_user, post: @post)
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
    if @post.update(post_params.except(:new_tags))
      assign_tags(@post)
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
    params.require(:post).permit(:title, :content, :image_url, tag_ids: [], new_tags: [])
  end

  def assign_tags(post)
    tag_ids = Array(params[:post][:tag_ids]).reject(&:blank?).map(&:to_i)
    new_tag_names = Array(params[:post][:new_tags]).reject(&:blank?)

    new_tags = new_tag_names.map do |tag_name|
      Tag.find_or_create_by(name: tag_name.strip)
    end

    post.tags = Tag.where(id: tag_ids) + new_tags
  end
end
