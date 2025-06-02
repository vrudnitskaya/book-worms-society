class BookmarksController < ApplicationController
  before_action :require_login
  before_action :set_post

  def create
    bookmark = Bookmark.find_by(user_id: current_user.id, post_id: @post.id)

    if bookmark
      if bookmark.user_id == current_user.id
        bookmark.destroy
        redirect_back fallback_location: root_path, notice: "Bookmark removed."
      else
        render "errors/forbidden", status: :forbidden
      end
    else
      bookmark = Bookmark.new(user: current_user, post: @post)

      if bookmark.save
        redirect_back fallback_location: root_path, notice: "Added to bookmarks."
      else
        redirect_back fallback_location: root_path, alert: "Failed to bookmark post."
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
