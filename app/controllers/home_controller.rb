class HomeController < ApplicationController
  def index
    @recent_posts = Post.order(created_at: :desc).limit(20)
    @top_tags = Tag.joins(:post_tags)
                    .group("tags.id")
                    .order("COUNT(post_tags.id) DESC")
                    .limit(20)
  end
end
