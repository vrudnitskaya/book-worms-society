class BookmarksController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    user = User.where.not(id: post.user_id).order("RANDOM()").first

    bookmark = Bookmark.find_or_initialize_by(user: user, post: post)

    if bookmark.persisted?
      flash[:notice] = "Bookmark already exists for user #{user.username}"
    elsif bookmark.save
      flash[:notice] = "Bookmark created for user #{user.username}"
    else
      flash[:alert] = "Failed to create bookmark"
    end

    redirect_to post_path(post)
  end
end
