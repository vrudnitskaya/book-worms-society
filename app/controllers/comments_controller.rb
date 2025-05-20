class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update]
  before_action :authorize_user!, only: [:edit, :update]

  def new
    @comment = Comment.new(
      parent_comment_id: params[:parent_comment_id],
      post_id: params[:post_id]
    )
  end

  def create
    user = User.order("RANDOM()").first # after will be changed for current_user
    @comment = Comment.new(comment_params)
    @comment.user = user

    if @comment.save
      redirect_to post_path(@comment.post_id), notice: "Comment added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to post_path(@comment.post_id), notice: "Comment updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_user!
    unless @comment.user_id == @comment.user.id
      redirect_to post_path(@comment.post_id), alert: "You can only edit your own comments."
    end
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_comment_id)
  end
end
