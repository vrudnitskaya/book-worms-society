class PostsController < ApplicationController
  def show
    @post = Post.find(params[:id])
    @tags = @post.tags
    @like_count = @post.likes.count
    @bookmark_count = Bookmark.where(post_id: @post.id).count
    @comments = @post.comments.where(parent_comment_id: nil).includes(:user)
  end
end
