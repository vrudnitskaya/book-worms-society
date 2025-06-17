class TagsController < ApplicationController
  def show
    @tag = Tag.find_by!(slug: params[:id])

    per_page = 5
    page = params[:page].to_i
    page = 1 if page < 1
    offset = (page - 1) * per_page

    @posts = @tag.posts.includes(:user).order(created_at: :desc).limit(per_page).offset(offset)

    @total_posts = @tag.posts.count
    @total_pages = (@total_posts.to_f / per_page).ceil
    @current_page = page

    @top_tags = Tag.joins(:posts).group(:id).order("COUNT(posts.id) DESC").limit(10)
    @recent_posts = Post.order(created_at: :desc).limit(5)

    @subscribed = logged_in? && current_user.tags.exists?(@tag.id)
  end
end
