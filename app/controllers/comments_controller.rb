class CommentsController < ApplicationController
  def new
    @comment = Comment.new(
      parent_comment_id: params[:parent_comment_id],
      post_id: params[:post_id]
    )
  end

  def create
    # temporary
    user = User.order("RANDOM()").first

    @comment = Comment.new(comment_params)
    @comment.user = user

    if @comment.save
      redirect_to post_path(@comment.post_id), notice: "Comment added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_comment_id)
  end
end
